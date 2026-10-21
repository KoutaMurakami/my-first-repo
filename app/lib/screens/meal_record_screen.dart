import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import '../data/meal_repository.dart';
import '../data/nutrition_targets.dart';
import '../database/app_database.dart';
import '../widgets/remaining_card.dart';

enum _SourceTab { myList, search, photo }

// --- 食事を記録する画面 ---
//
// docs/design/README.md「7. 食事を記録」に対応。
// 食品を「追加」していくと、その場で「記録した後の残り」がプレビューされ、
// 「記録する」で初めてDBに保存される(それまでは下書き = ドラフトとして画面内だけで持つ)。
class MealRecordScreen extends StatefulWidget {
  const MealRecordScreen({super.key, required this.database, required this.day});

  final AppDatabase database;

  // 記録する対象の日付。過去の日を表示中に開いた場合はその日に記録する。
  final DateTime day;

  @override
  State<MealRecordScreen> createState() => _MealRecordScreenState();
}

class _MealRecordScreenState extends State<MealRecordScreen> {
  late final MealRepository _repo = MealRepository(widget.database);

  NutritionTargets? _targets;
  DayIntake? _alreadyEaten;
  List<FoodInfo> _foods = [];

  final List<DraftItem> _draft = [];
  _SourceTab _tab = _SourceTab.search;
  String _query = '';
  late DateTime _eatenAt;
  bool _savedList = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _eatenAt = DateTime(widget.day.year, widget.day.month, widget.day.day,
        now.hour, now.minute);
    _load();
  }

  Future<void> _load() async {
    final targets = await loadTargets(widget.database);
    final eaten = await _repo.loadDayIntake(widget.day);
    final foods = await _repo.loadAllFoods();
    if (!mounted) return;
    setState(() {
      _targets = targets;
      _alreadyEaten = eaten;
      _foods = foods;
    });
  }

  // 「すでに食べた分 + 下書き」の栄養素合計。残りのプレビューに使う。
  NutrientAmounts get _previewTotals {
    final totals = <String, double>{...?_alreadyEaten?.totals};
    for (final item in _draft) {
      for (final key in nutrientLabels.keys) {
        totals[key] = (totals[key] ?? 0) + item.amount(key);
      }
    }
    return totals;
  }

  void _addFood(FoodInfo info, {double? grams}) {
    setState(() {
      _draft.add(DraftItem(food: info, quantityG: grams ?? info.food.servingG));
      _savedList = false;
    });
  }

  Future<void> _editQuantity(DraftItem item) async {
    final controller =
        TextEditingController(text: item.quantityG.round().toString());
    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.food.food.name),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(labelText: '量', suffixText: 'g'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () {
              final v = double.tryParse(controller.text);
              Navigator.pop(context, v != null && v > 0 ? v : null);
            },
            child: const Text('決定'),
          ),
        ],
      ),
    );
    if (result != null) setState(() => item.quantityG = result);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_eatenAt),
    );
    if (picked == null) return;
    setState(() {
      _eatenAt = DateTime(_eatenAt.year, _eatenAt.month, _eatenAt.day,
          picked.hour, picked.minute);
    });
  }

  Future<void> _saveAsList() async {
    final controller = TextEditingController(text: 'マイリスト');
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('マイリストに保存'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'リスト名'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;
    await _repo.saveMealList(name, _draft);
    if (mounted) setState(() => _savedList = true);
  }

  Future<void> _record() async {
    await _repo.saveMeal(_draft, _eatenAt);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final targets = _targets;
    if (targets == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('食事を記録')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final hh = _eatenAt.hour.toString().padLeft(2, '0');
    final mm = _eatenAt.minute.toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(title: const Text('食事を記録')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          RemainingCard(
            title: _draft.isEmpty ? '今日の残り' : 'この食事を記録した後の残り',
            targets: targets,
            eaten: _previewTotals,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ActionChip(
                avatar: const Icon(Icons.access_time, size: 16),
                label: Text('$hh:$mm'),
                onPressed: _pickTime,
              ),
            ],
          ),
          const SizedBox(height: 8),
          SegmentedButton<_SourceTab>(
            segments: const [
              ButtonSegment(value: _SourceTab.myList, label: Text('マイリスト')),
              ButtonSegment(value: _SourceTab.search, label: Text('検索')),
              ButtonSegment(value: _SourceTab.photo, label: Text('写真')),
            ],
            selected: {_tab},
            onSelectionChanged: (s) => setState(() => _tab = s.first),
          ),
          const SizedBox(height: 8),
          _tabBody(targets),
          const SizedBox(height: 16),
          _draftSection(),
        ],
      ),
    );
  }

  Widget _tabBody(NutritionTargets targets) {
    switch (_tab) {
      case _SourceTab.photo:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Text('写真からの自動認識(AI)は今後対応予定です',
                style: TextStyle(color: AppColors.textTertiary)),
          ),
        );
      case _SourceTab.myList:
        return _myListTab();
      case _SourceTab.search:
        return _searchTab(targets);
    }
  }

  Widget _myListTab() {
    return StreamBuilder<List<MealList>>(
      stream: _repo.watchMealLists(),
      builder: (context, snapshot) {
        final lists = snapshot.data ?? const [];
        if (lists.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text('マイリストはまだありません。\n食品を追加して「この内容をマイリストに保存」で作れます',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textTertiary)),
            ),
          );
        }
        return Column(
          children: [
            for (final list in lists)
              FutureBuilder<List<DraftItem>>(
                future: _repo.loadMealListItems(list.id),
                builder: (context, itemsSnap) {
                  final items = itemsSnap.data ?? const [];
                  final kcal = items.fold<double>(0, (a, b) => a + b.amount('kcal'));
                  final p = items.fold<double>(0, (a, b) => a + b.amount('p'));
                  return Card(
                    child: ListTile(
                      title: Text(list.name),
                      subtitle: Text(
                        '${items.map((e) => e.food.food.name).join('、')}\n'
                        '${kcal.round()}kcal · P ${p.round()}g',
                      ),
                      isThreeLine: true,
                      trailing: FilledButton.tonal(
                        onPressed: items.isEmpty
                            ? null
                            : () => setState(() {
                                  for (final it in items) {
                                    _draft.add(DraftItem(
                                        food: it.food, quantityG: it.quantityG));
                                  }
                                  _savedList = false;
                                }),
                        child: const Text('追加'),
                      ),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  Widget _searchTab(NutritionTargets targets) {
    final eaten = _previewTotals;
    final q = _query.trim();

    final List<RecommendedFood> shown;
    if (q.isEmpty) {
      // 未入力の時は「不足を補うおすすめ」順。
      shown = _repo.rankByDeficit(_foods, targets, eaten);
    } else {
      shown = [
        for (final f in _foods)
          if (f.food.name.contains(q)) RecommendedFood(info: f),
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: '食品を検索',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
        const SizedBox(height: 8),
        if (q.isEmpty)
          const Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text('不足を補うおすすめ',
                style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
          ),
        if (shown.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: Text('該当する食品がありません')),
          ),
        for (final r in shown)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(r.info.food.name),
            subtitle: Text(
              '${r.info.food.servingLabel} · '
              '${r.info.perServing('kcal').round()}kcal · '
              'P ${r.info.perServing('p').round()}g'
              '${r.tag == null ? '' : '\n${r.tag}'}',
            ),
            isThreeLine: r.tag != null,
            trailing: const Icon(Icons.add_circle_outline),
            onTap: () => _addFood(r.info),
          ),
      ],
    );
  }

  Widget _draftSection() {
    final kcal = _draft.fold<double>(0, (a, b) => a + b.amount('kcal'));
    final p = _draft.fold<double>(0, (a, b) => a + b.amount('p'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('このミールに追加済み',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        if (_draft.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('食品を追加するとここに並びます',
                style: TextStyle(color: AppColors.textTertiary)),
          ),
        for (final item in _draft)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(item.food.food.name),
            subtitle: Text(
              '${item.quantityG.round()}g · ${item.amount('kcal').round()}kcal · '
              'P ${item.amount('p').round()}g',
            ),
            onTap: () => _editQuantity(item),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() => _draft.remove(item)),
            ),
          ),
        if (_draft.isNotEmpty) ...[
          const Divider(),
          Text('合計 ${kcal.round()}kcal · P ${p.round()}g',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _savedList ? null : _saveAsList,
            child: Text(_savedList ? 'マイリストに保存しました' : 'この内容をマイリストに保存'),
          ),
        ],
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _draft.isEmpty ? null : _record,
            child: const Text('記録する'),
          ),
        ),
      ],
    );
  }
}
