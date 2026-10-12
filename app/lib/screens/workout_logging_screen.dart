import 'dart:async';

import 'package:drift/drift.dart' show OrderingTerm, Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../database/app_database.dart';
import 'my_training_list_screen.dart' show setTypeOptions;

String _groupTypeToSetType(String groupType) {
  switch (groupType) {
    case 'drop_set':
      return 'ドロップ';
    case 'pyramid_set':
      return 'ピラミッド';
    case 'super_set':
      return 'スーパー';
    case 'giant_set':
      return 'ジャイアント';
    default:
      return 'ストレート';
  }
}

String _setTypeToGroupTypeLocal(String setType) {
  switch (setType) {
    case 'ドロップ':
      return 'drop_set';
    case 'ピラミッド':
      return 'pyramid_set';
    case 'スーパー':
      return 'super_set';
    case 'ジャイアント':
      return 'giant_set';
    default:
      return 'normal';
  }
}

const Map<String, String> _assistByLabels = {
  'partner': 'パートナー',
  'trainer': 'トレーナー',
  'self': 'セルフ（片手補助）',
};

// --- セット記録画面 ---
//
// 1回のトレーニング(WorkoutSession)の中で、種目ごとのセットを記録していく画面。
// docs/design/README.md 「5. セット記録」に対応する、今回の実装で一番複雑な画面。
//
// 設計方針: DB上の正規化されたテーブル(groups/sets/assists)をそのまま画面に出すと
// 扱いづらいので、読み込み時に「画面表示用のまとまり」(_GroupVM/_SetVM)に組み立て直し、
// 以後はこのローカル状態を正として編集 → 都度DBへ書き込む、という流れにしている。
// (README: 「セット記録は1セットごとに即保存」という要件に対応)
class WorkoutLoggingScreen extends StatefulWidget {
  const WorkoutLoggingScreen({
    super.key,
    required this.database,
    required this.sessionId,
  });

  final AppDatabase database;
  final int sessionId;

  @override
  State<WorkoutLoggingScreen> createState() => _WorkoutLoggingScreenState();
}

class _WorkoutLoggingScreenState extends State<WorkoutLoggingScreen> {
  List<_GroupVM>? _groups;
  bool _restEnabled = true;

  // 同時に走らせるレストタイマーは1つだけ、という前提(README通り)。
  Timer? _restTimer;
  int? _activeRestSetId;
  int _restRemaining = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    for (final g in _groups ?? const <_GroupVM>[]) {
      for (final s in g.sets) {
        s.weightController.dispose();
        s.repsController.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _load() async {
    final db = widget.database;
    final groupRows = await (db.select(db.workoutSetGroups)
          ..where((t) => t.sessionId.equals(widget.sessionId))
          ..orderBy([(t) => OrderingTerm.asc(t.orderInSession)]))
        .get();

    final groups = <_GroupVM>[];
    for (final g in groupRows) {
      final setRows = await (db.select(db.workoutSets)
            ..where((t) => t.groupId.equals(g.id))
            ..orderBy([(t) => OrderingTerm.asc(t.orderInGroup)]))
          .get();
      if (setRows.isEmpty) continue;

      final exercise = await (db.select(db.exercises)
            ..where((t) => t.id.equals(setRows.first.exerciseId)))
          .getSingle();

      final previous = await _fetchPreviousSets(
        exerciseId: exercise.id,
        excludeSessionId: widget.sessionId,
      );

      final sets = <_SetVM>[];
      for (var i = 0; i < setRows.length; i++) {
        final row = setRows[i];
        final assistRows = await (db.select(db.workoutSetAssists)
              ..where((t) => t.setId.equals(row.id)))
            .get();
        final prev = i < previous.length ? previous[i] : null;
        sets.add(_SetVM(
          id: row.id,
          weightController:
              TextEditingController(text: _formatNum(row.weightKg)),
          repsController: TextEditingController(text: row.reps.toString()),
          isDone: row.isDone,
          previousLabel: prev == null
              ? '—'
              : '${_formatNum(prev.weightKg)}×${prev.reps}',
          previousWeight: prev?.weightKg,
          assist: assistRows.isEmpty ? null : assistRows.first,
        ));
      }

      groups.add(_GroupVM(
        groupId: g.id,
        exerciseId: exercise.id,
        exerciseName: exercise.name,
        setType: _groupTypeToSetType(g.groupType),
        sets: sets,
      ));
    }

    if (mounted) setState(() => _groups = groups);
  }

  // 同じ種目をやった、このセッション以外で一番新しいセッションのセットを取得する。
  // (「前回同種目との比較表示」要件のための処理。docs/requirements-fitness-app.md 2.1)
  //
  // Driftのjoin構文を使わず、2〜3段のシンプルなクエリを順番に投げる形にしている。
  // ホビー規模の個人アプリでは記録件数が多くないため、素直な書き方を優先した。
  Future<List<WorkoutSet>> _fetchPreviousSets({
    required int exerciseId,
    required int excludeSessionId,
  }) async {
    final db = widget.database;
    final allSetsForExercise = await (db.select(db.workoutSets)
          ..where((t) => t.exerciseId.equals(exerciseId)))
        .get();
    if (allSetsForExercise.isEmpty) return [];

    final groupIds = allSetsForExercise.map((s) => s.groupId).toSet();
    final groups = await (db.select(db.workoutSetGroups)
          ..where((t) => t.id.isIn(groupIds)))
        .get();
    final groupById = {for (final g in groups) g.id: g};

    final sessionIds = groups.map((g) => g.sessionId).toSet()
      ..remove(excludeSessionId);
    if (sessionIds.isEmpty) return [];

    final sessions = await (db.select(db.workoutSessions)
          ..where((t) => t.id.isIn(sessionIds))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
    if (sessions.isEmpty) return [];
    final latestSessionId = sessions.first.id;

    final latestGroupIds = groupIds.where(
      (id) => groupById[id]?.sessionId == latestSessionId,
    );

    final previousSets = allSetsForExercise
        .where((s) => latestGroupIds.contains(s.groupId))
        .toList()
      ..sort((a, b) => a.orderInGroup.compareTo(b.orderInGroup));
    return previousSets;
  }

  Future<void> _persistSet(_SetVM set) async {
    final weight = double.tryParse(set.weightController.text) ?? 0;
    final reps = int.tryParse(set.repsController.text) ?? 0;
    await (widget.database.update(widget.database.workoutSets)
          ..where((t) => t.id.equals(set.id)))
        .write(WorkoutSetsCompanion(
      weightKg: Value(weight),
      reps: Value(reps),
      isDone: Value(set.isDone),
    ));
  }

  Future<void> _toggleDone(_SetVM set) async {
    setState(() => set.isDone = !set.isDone);
    await _persistSet(set);
  }

  Future<void> _addSet(_GroupVM group) async {
    final last = group.sets.last;
    final db = widget.database;
    final newId = await db.into(db.workoutSets).insert(
          WorkoutSetsCompanion.insert(
            groupId: group.groupId,
            exerciseId: group.exerciseId,
            orderInGroup: group.sets.length,
            weightKg: double.tryParse(last.weightController.text) ?? 0,
            reps: int.tryParse(last.repsController.text) ?? 0,
          ),
        );
    setState(() {
      group.sets.add(_SetVM(
        id: newId,
        weightController:
            TextEditingController(text: last.weightController.text),
        repsController: TextEditingController(text: last.repsController.text),
        isDone: false,
        previousLabel: '—',
        previousWeight: null,
        assist: null,
      ));
    });
  }

  Future<void> _changeSetType(_GroupVM group, String setType) async {
    setState(() => group.setType = setType);
    await (widget.database.update(widget.database.workoutSetGroups)
          ..where((t) => t.id.equals(group.groupId)))
        .write(WorkoutSetGroupsCompanion(
      groupType: Value(_setTypeToGroupTypeLocal(setType)),
    ));
  }

  void _startRest(_SetVM set, {int seconds = 90}) {
    _restTimer?.cancel();
    setState(() {
      _activeRestSetId = set.id;
      _restRemaining = seconds;
    });
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restRemaining <= 1) {
        timer.cancel();
        setState(() {
          _restRemaining = 0;
          _activeRestSetId = null;
        });
      } else {
        setState(() => _restRemaining -= 1);
      }
    });
  }

  void _skipRest() {
    _restTimer?.cancel();
    setState(() => _activeRestSetId = null);
  }

  Future<void> _openAssistSheet(_SetVM set) async {
    final reps = int.tryParse(set.repsController.text) ?? 0;
    var scope = set.assist?.scope ?? 'part';
    var assistedReps = set.assist?.assistedReps ?? 0;
    var assistedBy = set.assist?.assistedBy ?? 'partner';
    final memoController =
        TextEditingController(text: set.assist?.memo ?? '');

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('フォーストレップ（補助レップ）',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'part', label: Text('最後の数回だけ補助')),
                      ButtonSegment(value: 'full', label: Text('セット全体を補助')),
                    ],
                    selected: {scope},
                    onSelectionChanged: (s) =>
                        setSheetState(() => scope = s.first),
                  ),
                  const SizedBox(height: 12),
                  if (scope == 'part') ...[
                    Row(
                      children: [
                        const Text('補助してもらった回数'),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: assistedReps > 0
                              ? () => setSheetState(() => assistedReps -= 1)
                              : null,
                        ),
                        Text('$assistedReps'),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => setSheetState(() => assistedReps += 1),
                        ),
                      ],
                    ),
                    Text(
                      '自力 ${(reps - assistedReps).clamp(0, reps)}回 '
                      '＋ 補助 $assistedReps回 = 計 $reps回',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ] else
                    Text(
                      'このセットの $reps回 すべてを補助ありとして記録します'
                      '（自己ベスト・前回比較の対象から除外）',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: _assistByLabels.entries
                        .map(
                          (e) => ChoiceChip(
                            label: Text(e.value),
                            selected: assistedBy == e.key,
                            onSelected: (_) =>
                                setSheetState(() => assistedBy = e.key),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: memoController,
                    decoration: const InputDecoration(labelText: 'メモ'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (set.assist != null)
                        TextButton(
                          onPressed: () async {
                            await (widget.database
                                    .delete(widget.database.workoutSetAssists)
                                  ..where((t) => t.id.equals(set.assist!.id)))
                                .go();
                            setState(() => set.assist = null);
                            if (context.mounted) Navigator.pop(context);
                          },
                          child: const Text('補助なしに戻す'),
                        ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('閉じる'),
                      ),
                      FilledButton(
                        onPressed: () async {
                          await _saveAssist(
                            set,
                            scope: scope,
                            assistedReps: scope == 'part' ? assistedReps : reps,
                            assistedBy: assistedBy,
                            memo: memoController.text.trim(),
                          );
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: const Text('保存'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _saveAssist(
    _SetVM set, {
    required String scope,
    required int assistedReps,
    required String assistedBy,
    required String memo,
  }) async {
    final db = widget.database;
    if (set.assist != null) {
      await (db.update(db.workoutSetAssists)
            ..where((t) => t.id.equals(set.assist!.id)))
          .write(WorkoutSetAssistsCompanion(
        scope: Value(scope),
        assistedReps: Value(assistedReps),
        assistedBy: Value(assistedBy),
        memo: Value(memo.isEmpty ? null : memo),
      ));
      final updated = await (db.select(db.workoutSetAssists)
            ..where((t) => t.id.equals(set.assist!.id)))
          .getSingle();
      setState(() => set.assist = updated);
    } else {
      final id = await db.into(db.workoutSetAssists).insert(
            WorkoutSetAssistsCompanion.insert(
              setId: set.id,
              scope: scope,
              assistedReps: Value(assistedReps),
              assistedBy: assistedBy,
              memo: Value(memo.isEmpty ? null : memo),
            ),
          );
      final inserted = await (db.select(db.workoutSetAssists)
            ..where((t) => t.id.equals(id)))
          .getSingle();
      setState(() => set.assist = inserted);
    }
  }

  Future<void> _pause() async {
    // 「中断して保存」: endedAt はセットせず、セッションを開いたまま画面だけ閉じる。
    // ここまでのセットは既に1セットごとに保存済みなので、追加の書き込みは不要。
    if (mounted) Navigator.pop(context);
  }

  Future<void> _finish() async {
    await (widget.database.update(widget.database.workoutSessions)
          ..where((t) => t.id.equals(widget.sessionId)))
        .write(WorkoutSessionsCompanion(
      endedAt: Value(DateTime.now()),
      status: const Value('completed'),
    ));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final groups = _groups;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _pause,
          tooltip: '中断して保存',
        ),
        title: const Text('● 記録中'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Text('レスト', style: TextStyle(fontSize: 12)),
                Switch(
                  value: _restEnabled,
                  onChanged: (v) => setState(() => _restEnabled = v),
                ),
              ],
            ),
          ),
        ],
      ),
      body: groups == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_activeRestSetId != null)
                  Container(
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          '残り ${(_restRemaining ~/ 60).toString().padLeft(1, '0')}:'
                          '${(_restRemaining % 60).toString().padLeft(2, '0')}',
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: _skipRest,
                          child: const Text('スキップ'),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      for (final group in groups)
                        _GroupCard(
                          group: group,
                          restEnabled: _restEnabled,
                          activeRestSetId: _activeRestSetId,
                          restRemaining: _restRemaining,
                          onToggleDone: _toggleDone,
                          onAddSet: () => _addSet(group),
                          onChangeSetType: (t) => _changeSetType(group, t),
                          onWeightChanged: (set) => _persistSet(set),
                          onRepsChanged: (set) => _persistSet(set),
                          onStartRest: _startRest,
                          onOpenAssist: _openAssistSheet,
                        ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _finish,
                        child: const Text('トレーニングを終了'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

String _formatNum(double v) {
  if (v == v.roundToDouble()) return v.toStringAsFixed(0);
  return v.toString();
}

class _GroupVM {
  _GroupVM({
    required this.groupId,
    required this.exerciseId,
    required this.exerciseName,
    required this.setType,
    required this.sets,
  });

  final int groupId;
  final int exerciseId;
  final String exerciseName;
  String setType;
  final List<_SetVM> sets;
}

class _SetVM {
  _SetVM({
    required this.id,
    required this.weightController,
    required this.repsController,
    required this.isDone,
    required this.previousLabel,
    required this.previousWeight,
    required this.assist,
  });

  final int id;
  final TextEditingController weightController;
  final TextEditingController repsController;
  bool isDone;
  String previousLabel;
  double? previousWeight;
  WorkoutSetAssist? assist;
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.group,
    required this.restEnabled,
    required this.activeRestSetId,
    required this.restRemaining,
    required this.onToggleDone,
    required this.onAddSet,
    required this.onChangeSetType,
    required this.onWeightChanged,
    required this.onRepsChanged,
    required this.onStartRest,
    required this.onOpenAssist,
  });

  final _GroupVM group;
  final bool restEnabled;
  final int? activeRestSetId;
  final int restRemaining;
  final void Function(_SetVM set) onToggleDone;
  final VoidCallback onAddSet;
  final void Function(String setType) onChangeSetType;
  final void Function(_SetVM set) onWeightChanged;
  final void Function(_SetVM set) onRepsChanged;
  final void Function(_SetVM set, {int seconds}) onStartRest;
  final void Function(_SetVM set) onOpenAssist;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(group.exerciseName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                DropdownButton<String>(
                  value: group.setType,
                  items: setTypeOptions
                      .map((t) => DropdownMenuItem(
                          value: t, child: Text('$t セット')))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) onChangeSetType(v);
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),
            for (var i = 0; i < group.sets.length; i++)
              _SetRow(
                index: i + 1,
                set: group.sets[i],
                restEnabled: restEnabled,
                isResting:
                    activeRestSetId == group.sets[i].id,
                restRemaining: restRemaining,
                onToggleDone: () => onToggleDone(group.sets[i]),
                onWeightChanged: () => onWeightChanged(group.sets[i]),
                onRepsChanged: () => onRepsChanged(group.sets[i]),
                onStartRest: () => onStartRest(group.sets[i]),
                onOpenAssist: () => onOpenAssist(group.sets[i]),
              ),
            TextButton(
              onPressed: onAddSet,
              child: const Text('＋ セットを追加'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SetRow extends StatelessWidget {
  const _SetRow({
    required this.index,
    required this.set,
    required this.restEnabled,
    required this.isResting,
    required this.restRemaining,
    required this.onToggleDone,
    required this.onWeightChanged,
    required this.onRepsChanged,
    required this.onStartRest,
    required this.onOpenAssist,
  });

  final int index;
  final _SetVM set;
  final bool restEnabled;
  final bool isResting;
  final int restRemaining;
  final VoidCallback onToggleDone;
  final VoidCallback onWeightChanged;
  final VoidCallback onRepsChanged;
  final VoidCallback onStartRest;
  final VoidCallback onOpenAssist;

  @override
  Widget build(BuildContext context) {
    final hasAssist = set.assist != null;
    final up = set.previousWeight != null &&
        (double.tryParse(set.weightController.text) ?? 0) >
            set.previousWeight!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onOpenAssist,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: hasAssist
                      ? Theme.of(context).colorScheme.tertiaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Text('$index', style: const TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: set.weightController,
                  textAlign: TextAlign.center,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                  ],
                  decoration: const InputDecoration(
                      isDense: true, suffixText: 'kg'),
                  onChanged: (_) => onWeightChanged(),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: set.repsController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                      isDense: true, suffixText: '回'),
                  onChanged: (_) => onRepsChanged(),
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 64,
                child: Text(
                  (up ? '↑' : '') + set.previousLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: up ? Theme.of(context).colorScheme.primary : Colors.grey,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  set.isDone ? Icons.check_circle : Icons.check_circle_outline,
                  color: set.isDone ? Theme.of(context).colorScheme.primary : null,
                ),
                onPressed: onToggleDone,
              ),
              if (restEnabled)
                SizedBox(
                  width: 48,
                  child: TextButton(
                    onPressed: onStartRest,
                    child: Text(
                      isResting ? '$restRemaining' : '休憩',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ),
            ],
          ),
          if (hasAssist)
            Padding(
              padding: const EdgeInsets.only(left: 32, top: 2),
              child: Text(
                set.assist!.scope == 'full'
                    ? 'セット全体を補助 · ${_assistByLabels[set.assist!.assistedBy]}'
                    : '補助 +${set.assist!.assistedReps ?? 0}回 · '
                        '${_assistByLabels[set.assist!.assistedBy]}',
                style: const TextStyle(fontSize: 11, color: Colors.brown),
              ),
            ),
        ],
      ),
    );
  }
}
