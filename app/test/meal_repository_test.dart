// 食事の保存・集計・おすすめ順位付けのユニットテスト。
// インメモリDBを使うので、端末の実データには影響しない。

import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/data/meal_repository.dart';
import 'package:fitness_app/data/nutrition_targets.dart';
import 'package:fitness_app/database/app_database.dart';

void main() {
  late AppDatabase db;
  late MealRepository repo;

  setUp(() async {
    db = AppDatabase.forTesting();
    await db.seedFoodsIfEmpty();
    repo = MealRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('食事を保存すると、その日の摂取量が「100gあたりの量×グラム数」で集計される', () async {
    final foods = await repo.loadAllFoods();
    final egg = foods.firstWhere((f) => f.food.name == '卵（全卵）');

    // 卵(100gあたり142kcal)を100g食べた記録。
    final now = DateTime.now();
    await repo.saveMeal([DraftItem(food: egg, quantityG: 100)], now);

    final intake = await repo.loadDayIntake(now);
    expect(intake.meals, hasLength(1));
    expect(intake.of('kcal'), closeTo(142, 0.01));
    expect(intake.of('p'), closeTo(12.2, 0.01));
  });

  test('別の日の記録は集計に含まれない', () async {
    final foods = await repo.loadAllFoods();
    final egg = foods.firstWhere((f) => f.food.name == '卵（全卵）');

    final now = DateTime.now();
    await repo.saveMeal(
      [DraftItem(food: egg, quantityG: 100)],
      now.subtract(const Duration(days: 1)),
    );

    final intake = await repo.loadDayIntake(now);
    expect(intake.meals, isEmpty);
    expect(intake.of('kcal'), 0);
  });

  test('食事を削除すると集計から消える', () async {
    final foods = await repo.loadAllFoods();
    final egg = foods.firstWhere((f) => f.food.name == '卵（全卵）');
    final now = DateTime.now();
    await repo.saveMeal([DraftItem(food: egg, quantityG: 50)], now);

    final before = await repo.loadDayIntake(now);
    await repo.deleteMeal(before.meals.single.id);

    final after = await repo.loadDayIntake(now);
    expect(after.meals, isEmpty);
  });

  test('マイリストを保存して中身を読み戻せる', () async {
    final foods = await repo.loadAllFoods();
    final milk = foods.firstWhere((f) => f.food.name == '牛乳');
    final natto = foods.firstWhere((f) => f.food.name == '納豆');

    await repo.saveMealList('朝の定番', [
      DraftItem(food: milk, quantityG: 200),
      DraftItem(food: natto, quantityG: 45),
    ]);

    final lists = await db.select(db.mealLists).get();
    expect(lists.single.name, '朝の定番');
    final items = await repo.loadMealListItems(lists.single.id);
    expect(items.map((e) => e.food.food.name), ['牛乳', '納豆']);
    expect(items.first.quantityG, 200);
  });

  test('何も食べていない状態では、カルシウムを多く補える食品が上位に出る', () async {
    final foods = await repo.loadAllFoods();
    const targets = NutritionTargets(
      kcal: 2200,
      p: 140,
      f: 60,
      c: 240,
      micro: microTargets,
    );

    final ranked = repo.rankByDeficit(foods, targets, const {});
    final topNames = ranked.take(5).map((r) => r.info.food.name).toList();

    // サバ缶(1缶でカルシウム260mg/100g×190g)やプロテインなど、
    // 1食分で目標を大きく満たせる食品が上位に来るはず。
    expect(topNames, contains('サバ缶（水煮）'));
    // 上位の食品にはどの栄養素を補えるかのタグが付く。
    expect(ranked.first.tag, isNotNull);
  });
}
