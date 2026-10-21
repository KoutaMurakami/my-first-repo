import 'package:drift/drift.dart' show OrderingTerm, TableUpdateQuery;
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../data/meal_repository.dart';
import '../data/nutrition_targets.dart';
import '../database/app_database.dart';
import '../widgets/remaining_card.dart';
import '../widgets/weight_trend_card.dart';
import 'meal_record_screen.dart';
import 'profile_screen.dart';

class _HomeData {
  const _HomeData({
    required this.measurements,
    required this.targetWeightKg,
    required this.intake,
    required this.targets,
  });

  final List<BodyMeasurement> measurements;
  final double? targetWeightKg;
  final DayIntake intake;
  final NutritionTargets targets;
}

// --- ホーム画面 ---
//
// docs/design/README.md「1. ホーム」に対応。
// 「体重の推移」と「今日の栄養の過不足」を1画面で把握するための画面で、
// これまで作った体重記録・食事記録・基本情報の3つのデータをまとめて表示する。
//
// 今回の実装範囲外: 「AIアドバイス」カード(AI機能は別フェーズでまとめて実装する方針)。
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.database,
    required this.onOpenBody,
  });

  final AppDatabase database;

  // 体重カードをタップした時に「からだ」タブへ移動するための関数(タブ切り替えは親が持っている)。
  final VoidCallback onOpenBody;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final MealRepository _repo = MealRepository(widget.database);
  late final Stream<_HomeData> _stream = _watch();

  static const _weekdays = ['月', '火', '水', '木', '金', '土', '日'];

  // 体重記録・食事記録・基本情報のどれかが変わるたびに、画面用データを作り直して流す。
  Stream<_HomeData> _watch() async* {
    final db = widget.database;

    Future<_HomeData> load() async {
      final profile = await db.loadOrCreateProfile();
      final measurements = await (db.select(
        db.bodyMeasurements,
      )..orderBy([(t) => OrderingTerm.asc(t.measuredAt)])).get();
      return _HomeData(
        measurements: measurements,
        targetWeightKg: profile.targetWeightKg,
        intake: await _repo.loadDayIntake(DateTime.now()),
        targets: await loadTargets(db),
      );
    }

    yield await load();
    await for (final _ in db.tableUpdates(
      TableUpdateQuery.onAllTables([
        db.bodyMeasurements,
        db.mealLogs,
        db.profiles,
      ]),
    )) {
      yield await load();
    }
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(database: widget.database),
      ),
    );
  }

  void _openMealRecord() {
    final n = DateTime.now();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MealRecordScreen(
          database: widget.database,
          day: DateTime(n.year, n.month, n.day),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateText =
        '${now.year}年${now.month}月${now.day}日 ${_weekdays[now.weekday - 1]}曜日';

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<_HomeData>(
          stream: _stream,
          builder: (context, snapshot) {
            final data = snapshot.data;
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dateText,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '今日の記録',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton.outlined(
                      icon: const Icon(Icons.settings_outlined),
                      tooltip: '基本情報',
                      onPressed: _openSettings,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (data == null)
                  const Padding(
                    padding: EdgeInsets.only(top: 48),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else ...[
                  WeightTrendCard(
                    measurements: data.measurements,
                    targetWeightKg: data.targetWeightKg,
                    onTap: widget.onOpenBody,
                  ),
                  const SizedBox(height: 14),
                  RemainingCard(
                    title: '今日の栄養',
                    targets: data.targets,
                    eaten: data.intake.totals,
                    showBurn: true,
                    onRecordMeal: _openMealRecord,
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
