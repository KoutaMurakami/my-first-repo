import 'package:drift/drift.dart' show OrderingTerm, Value;
import 'package:flutter/material.dart';

import '../database/app_database.dart';
import 'exercise_select_screen.dart';
import 'my_training_list_screen.dart';
import 'workout_logging_screen.dart';

// --- 筋トレ画面(ハブ) ---
//
// docs/design/README.md 「3. 筋トレ」に対応する画面。
// ただし今回の実装範囲(筋トレ記録一式)では、基本情報(プロフィール)画面がまだ無いため
// 「分割法カード」「AIメニュー提案カード」は対象外としている
// (分割法・基礎代謝/TDEEの計算が前提になる機能のため、基本情報画面の実装フェーズで追加する)。
class WorkoutHomeScreen extends StatefulWidget {
  const WorkoutHomeScreen({super.key, required this.database});

  final AppDatabase database;

  @override
  State<WorkoutHomeScreen> createState() => _WorkoutHomeScreenState();
}

class _WorkoutHomeScreenState extends State<WorkoutHomeScreen> {
  Future<void> _startByExercise() async {
    final exercise = await Navigator.push<Exercise>(
      context,
      MaterialPageRoute(
        builder: (_) => ExerciseSelectScreen(database: widget.database),
      ),
    );
    if (exercise == null) return;

    final db = widget.database;
    final sessionId = await db.into(db.workoutSessions).insert(
          WorkoutSessionsCompanion.insert(startedAt: DateTime.now()),
        );
    final groupId = await db.into(db.workoutSetGroups).insert(
          WorkoutSetGroupsCompanion.insert(
            sessionId: sessionId,
            orderInSession: 0,
          ),
        );
    await db.into(db.workoutSets).insert(
          WorkoutSetsCompanion.insert(
            groupId: groupId,
            exerciseId: exercise.id,
            orderInGroup: 0,
            weightKg: 0,
            reps: 10,
          ),
        );

    if (mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              WorkoutLoggingScreen(database: widget.database, sessionId: sessionId),
        ),
      );
      setState(() {}); // 戻ってきたら履歴・中断中カードを再読み込み
    }
  }

  Future<void> _openMyTrainingLists() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MyTrainingListScreen(database: widget.database),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('筋トレ')),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            FutureBuilder<WorkoutSession?>(
              future: _findPausedSession(),
              builder: (context, snapshot) {
                final paused = snapshot.data;
                if (paused == null) return const SizedBox.shrink();
                return _PausedSessionCard(
                  database: widget.database,
                  session: paused,
                  onChanged: () => setState(() {}),
                );
              },
            ),
            const SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: _openMyTrainingLists,
              style: FilledButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(16),
              ),
              child: const Text('マイトレから開始 →'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _startByExercise,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: const Text('＋ 種目を選んで記録する'),
            ),
            const SizedBox(height: 24),
            const Text('トレーニング履歴',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            FutureBuilder<List<_HistoryEntry>>(
              future: _loadHistory(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final history = snapshot.data!;
                if (history.isEmpty) {
                  return const Text('まだ記録がありません', style: TextStyle(color: Colors.grey));
                }
                return Column(
                  children: history
                      .map((h) => Card(
                            child: ListTile(
                              title: Text(h.exerciseNames.join(' / ')),
                              subtitle: Text(
                                '${h.date} · ${h.exerciseCount}種目 · ${h.minutes}分'
                                '${h.aborted ? '（途中終了）' : ''}',
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('${h.totalSets}セット'),
                                  Text(
                                    h.kcal == null ? '—' : '${h.kcal}kcal',
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.brown),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<WorkoutSession?> _findPausedSession() async {
    final db = widget.database;
    final rows = await (db.select(db.workoutSessions)
          ..where((t) => t.endedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
          ..limit(1))
        .get();
    return rows.isEmpty ? null : rows.first;
  }

  Future<List<_HistoryEntry>> _loadHistory() async {
    final db = widget.database;
    final sessions = await (db.select(db.workoutSessions)
          ..where((t) => t.endedAt.isNotNull())
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
          ..limit(30))
        .get();

    // 消費kcal計算(docs/design/README.md: METs 5.0 × 体重kg × 時間h × 1.05)に使う体重。
    // 直近の体組成記録を1件だけ取得しておき、全セッション共通で使う
    // (セッションごとの厳密な当時の体重ではなく、簡易的な現在値での概算とする)。
    final latestWeight = await (db.select(db.bodyMeasurements)
          ..orderBy([(t) => OrderingTerm.desc(t.measuredAt)])
          ..limit(1))
        .getSingleOrNull();

    final entries = <_HistoryEntry>[];
    for (final session in sessions) {
      final groups = await (db.select(db.workoutSetGroups)
            ..where((t) => t.sessionId.equals(session.id)))
          .get();
      final groupIds = groups.map((g) => g.id).toSet();
      if (groupIds.isEmpty) continue;

      final sets = await (db.select(db.workoutSets)
            ..where((t) => t.groupId.isIn(groupIds)))
          .get();
      if (sets.isEmpty) continue;

      final exerciseIds = sets.map((s) => s.exerciseId).toSet();
      final exercises = await (db.select(db.exercises)
            ..where((t) => t.id.isIn(exerciseIds)))
          .get();

      final minutes = session.endedAt == null
          ? 0
          : session.endedAt!.difference(session.startedAt).inMinutes;
      final kcal = latestWeight == null
          ? null
          : (5.0 * latestWeight.weightKg * (minutes / 60) * 1.05).round();

      entries.add(_HistoryEntry(
        date: '${session.startedAt.month}/${session.startedAt.day}',
        exerciseNames: exercises.map((e) => e.name).toList(),
        exerciseCount: exercises.length,
        minutes: minutes,
        totalSets: sets.length,
        kcal: kcal,
        aborted: session.status == 'aborted',
      ));
    }
    return entries;
  }
}

class _PausedSessionCard extends StatelessWidget {
  const _PausedSessionCard({
    required this.database,
    required this.session,
    required this.onChanged,
  });

  final AppDatabase database;
  final WorkoutSession session;
  final VoidCallback onChanged;

  Future<_PausedInfo> _load() async {
    final groups = await (database.select(database.workoutSetGroups)
          ..where((t) => t.sessionId.equals(session.id)))
        .get();
    final groupIds = groups.map((g) => g.id).toSet();
    final sets = groupIds.isEmpty
        ? <WorkoutSet>[]
        : await (database.select(database.workoutSets)
              ..where((t) => t.groupId.isIn(groupIds)))
            .get();
    final exerciseName = sets.isEmpty
        ? 'トレーニング'
        : (await (database.select(database.exercises)
                  ..where((t) => t.id.equals(sets.first.exerciseId)))
                .getSingle())
            .name;
    return _PausedInfo(
      exerciseName: exerciseName,
      done: sets.where((s) => s.isDone).length,
      total: sets.length,
    );
  }

  Future<void> _finishHere(BuildContext context) async {
    await (database.update(database.workoutSessions)
          ..where((t) => t.id.equals(session.id)))
        .write(WorkoutSessionsCompanion(
      endedAt: Value(DateTime.now()),
      status: const Value('aborted'),
    ));
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_PausedInfo>(
      future: _load(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final info = snapshot.data!;
        return Card(
          color: Theme.of(context).colorScheme.secondaryContainer,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('中断中：${info.exerciseName}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${info.done} / ${info.total} セット記録済み'),
                const Text('中断までの記録は保存されています',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WorkoutLoggingScreen(
                                database: database,
                                sessionId: session.id,
                              ),
                            ),
                          );
                          onChanged();
                        },
                        child: const Text('再開する'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _finishHere(context),
                        child: const Text('ここまでで終了'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PausedInfo {
  _PausedInfo({required this.exerciseName, required this.done, required this.total});
  final String exerciseName;
  final int done;
  final int total;
}

class _HistoryEntry {
  _HistoryEntry({
    required this.date,
    required this.exerciseNames,
    required this.exerciseCount,
    required this.minutes,
    required this.totalSets,
    required this.kcal,
    required this.aborted,
  });

  final String date;
  final List<String> exerciseNames;
  final int exerciseCount;
  final int minutes;
  final int totalSets;
  final int? kcal;
  final bool aborted;
}
