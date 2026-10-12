import 'package:drift/drift.dart' show OrderingTerm, Value;
import 'package:flutter/material.dart';

import '../database/app_database.dart';

// 種目選択画面に出す部位チップ。「すべて」はフィルター無しを表す特別扱い。
// docs/design/README.md「4. 種目選択」の仕様(部位チップ: すべて/胸/背中/脚/肩/腕/体幹)に準拠。
const List<String> bodyPartFilters = ['すべて', '胸', '背中', '脚', '肩', '腕', '体幹'];

// --- 種目選択画面 ---
//
// 検索・部位フィルターで種目マスタ(Exercises)から種目を選ぶ画面。
// 選んだ種目は Navigator.pop(context, exercise) で呼び出し元に返す仕組みにしている。
// こうしておくと、「新規セッション開始」からも「マイトレ編集」からも、
// 同じこの画面を使い回せる(呼び出し元が選択結果を使って好きに処理できる)。
class ExerciseSelectScreen extends StatefulWidget {
  const ExerciseSelectScreen({super.key, required this.database});

  final AppDatabase database;

  @override
  State<ExerciseSelectScreen> createState() => _ExerciseSelectScreenState();
}

class _ExerciseSelectScreenState extends State<ExerciseSelectScreen> {
  final _searchController = TextEditingController();
  String _selectedBodyPart = 'すべて';
  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _addCustomExercise() async {
    final nameController = TextEditingController();
    String bodyPart = bodyPartFilters[1]; // デフォルトは「胸」

    final result = await showDialog<Exercise>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('種目を手入力する'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: '種目名'),
                    autofocus: true,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: bodyPart,
                    decoration: const InputDecoration(labelText: '部位'),
                    items: bodyPartFilters
                        .skip(1) // 「すべて」は選択肢から除外
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setDialogState(() => bodyPart = v);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('キャンセル'),
                ),
                FilledButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;
                    final id = await widget.database
                        .into(widget.database.exercises)
                        .insert(
                          ExercisesCompanion.insert(
                            name: name,
                            bodyPart: bodyPart,
                            isCustom: const Value(true),
                          ),
                        );
                    final inserted = await (widget.database
                            .select(widget.database.exercises)
                          ..where((t) => t.id.equals(id)))
                        .getSingle();
                    if (context.mounted) Navigator.pop(context, inserted);
                  },
                  child: const Text('追加する'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && mounted) {
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = widget.database.select(widget.database.exercises)
      ..orderBy([(t) => OrderingTerm.asc(t.name)]);

    return Scaffold(
      appBar: AppBar(title: const Text('種目を選ぶ')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: '種目を検索',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _searchText = v.trim()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: bodyPartFilters.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final part = bodyPartFilters[i];
                  final selected = part == _selectedBodyPart;
                  return ChoiceChip(
                    label: Text(part),
                    selected: selected,
                    onSelected: (_) =>
                        setState(() => _selectedBodyPart = part),
                  );
                },
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: StreamBuilder<List<Exercise>>(
              stream: query.watch(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final all = snapshot.data!;
                final filtered = all.where((e) {
                  final matchesPart = _selectedBodyPart == 'すべて' ||
                      e.bodyPart == _selectedBodyPart;
                  final matchesSearch = _searchText.isEmpty ||
                      e.name.contains(_searchText);
                  return matchesPart && matchesSearch;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('該当する種目がありません'));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final e = filtered[i];
                    return ListTile(
                      title: Text(e.name),
                      subtitle: Text(e.bodyPart),
                      trailing: const Icon(Icons.add),
                      onTap: () => Navigator.pop(context, e),
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
                onPressed: _addCustomExercise,
                child: const Text('リストにない種目を手入力する'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
