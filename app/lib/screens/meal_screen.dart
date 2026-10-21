import 'package:drift/drift.dart' show TableUpdateQuery;
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../data/meal_repository.dart';
import '../data/nutrition_targets.dart';
import '../database/app_database.dart';
import '../widgets/remaining_card.dart';
import 'meal_record_screen.dart';

// --- 食事画面 ---
//
// docs/design/README.md「6. 食事」に対応。
// 日付ごとのカロリー・PFC・不足栄養素のサマリと、
// 朝昼夕の固定枠ではなく「時刻順のタイムライン」で食事を一覧する。
class MealScreen extends StatefulWidget {
  const MealScreen({super.key, required this.database});

  final AppDatabase database;

  @override
  State<MealScreen> createState() => _MealScreenState();
}

class _MealViewData {
  const _MealViewData(this.intake, this.targets);
  final DayIntake intake;
  final NutritionTargets targets;
}

class _MealScreenState extends State<MealScreen> {
  late final MealRepository _repo = MealRepository(widget.database);
  DateTime _day = _today();
  late Stream<_MealViewData> _stream = _watch();

  static DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  bool get _isToday => _day == _today();

  // 食事記録・基本情報・体重記録のどれかが変わるたびに、画面用データを作り直して流す。
  // (基本情報を変えると目標摂取量が変わるため、食事記録以外のテーブルも監視している)
  // StreamBuilder に毎回新しいStreamを渡すとちらつくので、State に1本だけ持たせている。
  Stream<_MealViewData> _watch() async* {
    final db = widget.database;
    Future<_MealViewData> load() async => _MealViewData(
          await _repo.loadDayIntake(_day),
          await loadTargets(db),
        );

    yield await load();
    await for (final _ in db.tableUpdates(TableUpdateQuery.onAllTables(
        [db.mealLogs, db.profiles, db.bodyMeasurements]))) {
      yield await load();
    }
  }

  void _moveDay(int diff) => setState(() {
        _day = _day.add(Duration(days: diff));
        _stream = _watch();
      });

  Future<void> _openRecord() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MealRecordScreen(database: widget.database, day: _day),
      ),
    );
  }

  Future<void> _confirmDelete(MealEntry meal) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('この食事記録を削除しますか?'),
        content: Text(meal.items.map((e) => e.name).join('、')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('削除'),
          ),
        ],
      ),
    );
    if (ok == true) await _repo.deleteMeal(meal.id);
  }

  @override
  Widget build(BuildContext context) {
    final label = '${_day.month}/${_day.day}${_isToday ? '(今日)' : ''}';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => _moveDay(-1),
            ),
            Text(label, style: const TextStyle(fontSize: 16)),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: _isToday ? null : () => _moveDay(1),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<_MealViewData>(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final intake = snapshot.data!.intake;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              RemainingCard(
                title: _isToday ? '今日の残り' : '$labelの摂取',
                targets: snapshot.data!.targets,
                eaten: intake.totals,
              ),
              const SizedBox(height: 16),
              const Text('食事の記録',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (intake.meals.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('まだ記録がありません',
                      style: TextStyle(color: AppColors.textTertiary)),
                ),
              for (final meal in intake.meals) _mealTile(meal),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _openRecord,
                child: const Text('＋ 食事を記録する'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _mealTile(MealEntry meal) {
    final hh = meal.eatenAt.hour.toString().padLeft(2, '0');
    final mm = meal.eatenAt.minute.toString().padLeft(2, '0');
    return Card(
      child: ListTile(
        leading: Text('$hh:$mm', style: const TextStyle(fontWeight: FontWeight.bold)),
        title: Text(meal.items.map((e) => e.name).join('、')),
        subtitle: Text('${meal.kcal.round()}kcal · P ${meal.p.round()}g'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _confirmDelete(meal),
        ),
      ),
    );
  }
}
