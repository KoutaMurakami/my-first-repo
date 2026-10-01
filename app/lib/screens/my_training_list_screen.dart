import 'package:drift/drift.dart' show OrderingTerm, Value;
import 'package:flutter/material.dart';

import '../database/app_database.dart';
import 'exercise_select_screen.dart';
import 'workout_logging_screen.dart';

// セット形式のチップ。種目選択・セット記録画面と共通の5種類。
// docs/design/README.md の setTypes() に対応。
const List<String> setTypeOptions = ['ストレート', 'ピラミッド', 'ドロップ', 'スーパー', 'ジャイアント'];

// --- マイトレリスト一覧画面 ---
//
// よく使う種目の組み合わせ(MyTrainingLists + MyTrainingListItems)を
// 一覧表示し、「開始」でそのままトレーニングを始められるようにする画面。
class MyTrainingListScreen extends StatelessWidget {
  const MyTrainingListScreen({super.key, required this.database});

  final AppDatabase database;

  Future<void> _createList(BuildContext context) async {
    final id = await database.into(database.myTrainingLists).insert(
          const MyTrainingListsCompanion(name: Value('新しいリスト')),
        );
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              MyTrainingListEditScreen(database: database, listId: id),
        ),
      );
    }
  }

  // マイトレリストの内容から新しいWorkoutSessionを作り、セット記録画面に遷移する。
  // 「よく使う種目構成を、毎回入力し直さずワンタップで開始できる」というマイトレリストの
  // 目的(docs/requirements-fitness-app.md 2.1)を実現する部分。
  Future<void> _startFromList(BuildContext context, int listId) async {
    final items = await (database.select(database.myTrainingListItems)
          ..where((t) => t.listId.equals(listId))
          ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
        .get();

    if (items.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('種目が登録されていません')),
        );
      }
      return;
    }

    final sessionId = await database.into(database.workoutSessions).insert(
          WorkoutSessionsCompanion.insert(startedAt: DateTime.now()),
        );

    var orderInSession = 0;
    for (final item in items) {
      final groupId = await database.into(database.workoutSetGroups).insert(
            WorkoutSetGroupsCompanion.insert(
              sessionId: sessionId,
              groupType: Value(_setTypeToGroupType(item.setType)),
              orderInSession: orderInSession++,
            ),
          );

      // targetReps("6–10"のような範囲表記)から最初の数値だけ取り出し、初期値にする。
      final repsMatch = RegExp(r'\d+').firstMatch(item.targetReps);
      final initialReps = repsMatch != null ? int.parse(repsMatch.group(0)!) : 10;

      for (var i = 0; i < item.targetSets; i++) {
        await database.into(database.workoutSets).insert(
              WorkoutSetsCompanion.insert(
                groupId: groupId,
                exerciseId: item.exerciseId,
                orderInGroup: i,
                weightKg: 0,
                reps: initialReps,
              ),
            );
      }
    }

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              WorkoutLoggingScreen(database: database, sessionId: sessionId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('マイトレ')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'よく使うメニューを保存して、ワンタップで開始。'
                '「編集」で種目ごとのセット方式を選べます',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<MyTrainingList>>(
              stream: database.select(database.myTrainingLists).watch(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final lists = snapshot.data!;
                if (lists.isEmpty) {
                  return const Center(child: Text('まだマイトレリストがありません'));
                }
                return ListView.builder(
                  itemCount: lists.length,
                  itemBuilder: (context, i) {
                    final list = lists[i];
                    return _MyTrainingListTile(
                      database: database,
                      list: list,
                      onStart: () => _startFromList(context, list.id),
                      onEdit: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MyTrainingListEditScreen(
                            database: database,
                            listId: list.id,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton(
                onPressed: () => _createList(context),
                child: const Text('＋ 新しいリストを作成'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _setTypeToGroupType(String setType) {
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

class _MyTrainingListTile extends StatelessWidget {
  const _MyTrainingListTile({
    required this.database,
    required this.list,
    required this.onStart,
    required this.onEdit,
  });

  final AppDatabase database;
  final MyTrainingList list;
  final VoidCallback onStart;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(list.name,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            FutureBuilder<List<_ItemWithExercise>>(
              future: _loadItems(database, list.id),
              builder: (context, snapshot) {
                final items = snapshot.data ?? const [];
                if (items.isEmpty) {
                  return const Text('種目未登録', style: TextStyle(color: Colors.grey));
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: items
                      .map(
                        (it) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Expanded(child: Text(it.exercise.name)),
                              Chip(
                                label: Text(it.item.setType,
                                    style: const TextStyle(fontSize: 11)),
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              const SizedBox(width: 6),
                              Text('${it.item.targetSets}セット × ${it.item.targetReps}回'),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FilledButton(onPressed: onStart, child: const Text('開始')),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(onPressed: onEdit, child: const Text('編集')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 件数の少ないマイトレ項目では、joinを組むより
  // 「項目を取得 → 1件ずつ種目名を引く」という素直な2段クエリの方が読みやすいと判断した。
  Future<List<_ItemWithExercise>> _loadItems(AppDatabase db, int listId) async {
    final items = await (db.select(db.myTrainingListItems)
          ..where((t) => t.listId.equals(listId))
          ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
        .get();
    final result = <_ItemWithExercise>[];
    for (final item in items) {
      final exercise = await (db.select(db.exercises)
            ..where((t) => t.id.equals(item.exerciseId)))
          .getSingle();
      result.add(_ItemWithExercise(item: item, exercise: exercise));
    }
    return result;
  }
}

class _ItemWithExercise {
  _ItemWithExercise({required this.item, required this.exercise});
  final MyTrainingListItem item;
  final Exercise exercise;
}

// --- マイトレリスト編集画面 ---
class MyTrainingListEditScreen extends StatefulWidget {
  const MyTrainingListEditScreen({
    super.key,
    required this.database,
    required this.listId,
  });

  final AppDatabase database;
  final int listId;

  @override
  State<MyTrainingListEditScreen> createState() =>
      _MyTrainingListEditScreenState();
}

class _MyTrainingListEditScreenState extends State<MyTrainingListEditScreen> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _loadName();
  }

  Future<void> _loadName() async {
    final list = await (widget.database.select(widget.database.myTrainingLists)
          ..where((t) => t.id.equals(widget.listId)))
        .getSingle();
    _nameController.text = list.name;
    if (mounted) setState(() {});
  }

  Future<void> _saveName(String name) async {
    await (widget.database.update(widget.database.myTrainingLists)
          ..where((t) => t.id.equals(widget.listId)))
        .write(MyTrainingListsCompanion(name: Value(name)));
  }

  Future<void> _addExercise() async {
    final exercise = await Navigator.push<Exercise>(
      context,
      MaterialPageRoute(
        builder: (_) => ExerciseSelectScreen(database: widget.database),
      ),
    );
    if (exercise == null) return;

    final currentCount = await (widget.database.select(
            widget.database.myTrainingListItems)
          ..where((t) => t.listId.equals(widget.listId)))
        .get();

    await widget.database.into(widget.database.myTrainingListItems).insert(
          MyTrainingListItemsCompanion.insert(
            listId: widget.listId,
            exerciseId: exercise.id,
            targetSets: 3,
            targetReps: '8–12',
            orderIndex: currentCount.length,
          ),
        );
  }

  Future<void> _removeItem(int itemId) async {
    await (widget.database.delete(widget.database.myTrainingListItems)
          ..where((t) => t.id.equals(itemId)))
        .go();
  }

  Future<void> _updateItem(
    MyTrainingListItem item, {
    int? targetSets,
    String? setType,
  }) async {
    await (widget.database.update(widget.database.myTrainingListItems)
          ..where((t) => t.id.equals(item.id)))
        .write(
      MyTrainingListItemsCompanion(
        targetSets: targetSets != null ? Value(targetSets) : const Value.absent(),
        setType: setType != null ? Value(setType) : const Value.absent(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _nameController,
          decoration: const InputDecoration(border: InputBorder.none),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          onSubmitted: _saveName,
          onEditingComplete: () => _saveName(_nameController.text),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _saveName(_nameController.text);
              Navigator.pop(context);
            },
            child: const Text('完了'),
          ),
        ],
      ),
      body: StreamBuilder<List<MyTrainingListItem>>(
        stream: (widget.database.select(widget.database.myTrainingListItems)
              ..where((t) => t.listId.equals(widget.listId))
              ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
            .watch(),
        builder: (context, snapshot) {
          final items = snapshot.data ?? const [];
          return ListView(
            children: [
              for (final item in items)
                _EditableItemTile(
                  database: widget.database,
                  item: item,
                  onRemove: () => _removeItem(item.id),
                  onChanged: (sets, setType) =>
                      _updateItem(item, targetSets: sets, setType: setType),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: OutlinedButton(
                  onPressed: _addExercise,
                  child: const Text('＋ 種目を追加'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EditableItemTile extends StatelessWidget {
  const _EditableItemTile({
    required this.database,
    required this.item,
    required this.onRemove,
    required this.onChanged,
  });

  final AppDatabase database;
  final MyTrainingListItem item;
  final VoidCallback onRemove;
  final void Function(int? sets, String? setType) onChanged;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Exercise>(
      future: (database.select(database.exercises)
            ..where((t) => t.id.equals(item.exerciseId)))
          .getSingle(),
      builder: (context, snapshot) {
        final name = snapshot.data?.name ?? '...';
        return ListTile(
          title: Text(name),
          subtitle: Wrap(
            spacing: 6,
            children: setTypeOptions
                .map(
                  (t) => ChoiceChip(
                    label: Text(t, style: const TextStyle(fontSize: 11)),
                    selected: item.setType == t,
                    onSelected: (_) => onChanged(null, t),
                    visualDensity: VisualDensity.compact,
                  ),
                )
                .toList(),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: item.targetSets > 1
                    ? () => onChanged(item.targetSets - 1, null)
                    : null,
              ),
              Text('${item.targetSets}セット'),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => onChanged(item.targetSets + 1, null),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: onRemove,
              ),
            ],
          ),
        );
      },
    );
  }
}
