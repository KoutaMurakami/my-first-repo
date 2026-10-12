import 'package:drift/drift.dart'
    show BooleanExpressionOperators, ComparableExpr, OrderingTerm;

import '../database/app_database.dart';
import 'nutrition_targets.dart';

// --- 食事データの読み書きをまとめた層 ---
//
// 画面側(MealScreen/MealRecordScreen)にDriftのクエリを直接書くと、
// 「栄養素は100gあたりの量×食べたグラム数」という計算が画面ごとに重複してしまう。
// そこで、食事まわりのDB操作と栄養計算はこのクラスに集約している。

// 栄養素コード(kcal/p/f/c/ca/...)→量 のまとまり。
typedef NutrientAmounts = Map<String, double>;

// 食品1件と、その100gあたり栄養素量。
class FoodInfo {
  const FoodInfo({required this.food, required this.per100g});

  final Food food;
  final NutrientAmounts per100g;

  // 指定グラム数あたりの栄養素量。
  double amountFor(String key, double grams) =>
      (per100g[key] ?? 0) * grams / 100;

  // 「1食分」あたりの栄養素量。
  double perServing(String key) => amountFor(key, food.servingG);
}

// 記録前(ドラフト)の1品。
class DraftItem {
  DraftItem({required this.food, required this.quantityG});

  final FoodInfo food;
  double quantityG;

  double amount(String key) => food.amountFor(key, quantityG);
}

// 記録済みの食事の中の1品(画面表示用)。
class MealItemView {
  const MealItemView({
    required this.name,
    required this.quantityG,
    required this.kcal,
    required this.p,
  });

  final String name;
  final double quantityG;
  final double kcal;
  final double p;
}

// 記録済みの1回の食事(画面表示用)。
class MealEntry {
  const MealEntry({
    required this.id,
    required this.eatenAt,
    required this.items,
  });

  final int id;
  final DateTime eatenAt;
  final List<MealItemView> items;

  double get kcal => items.fold(0, (a, b) => a + b.kcal);
  double get p => items.fold(0, (a, b) => a + b.p);
}

// 1日分の摂取量と食事一覧。
class DayIntake {
  const DayIntake({required this.totals, required this.meals});

  final NutrientAmounts totals;
  final List<MealEntry> meals;

  double of(String key) => totals[key] ?? 0;
}

// おすすめ表示用: 食品と「どの栄養素をどれだけ補えるか」のタグ。
class RecommendedFood {
  const RecommendedFood({required this.info, this.tag});

  final FoodInfo info;
  final String? tag; // 例: "カルシウム +220mg"
}

class MealRepository {
  MealRepository(this.db);

  final AppDatabase db;

  // ---- 食品 ----

  Future<List<FoodInfo>> loadAllFoods() async {
    final nutrientRows = await db.select(db.nutrients).get();
    final keyById = {for (final n in nutrientRows) n.id: n.key};

    final foodRows = await (db.select(
      db.foods,
    )..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
    final fnRows = await db.select(db.foodNutrients).get();

    final byFood = <int, NutrientAmounts>{};
    for (final fn in fnRows) {
      final key = keyById[fn.nutrientId];
      if (key == null) continue;
      (byFood[fn.foodId] ??= {})[key] = fn.amountPer100g;
    }

    return [
      for (final f in foodRows)
        FoodInfo(food: f, per100g: byFood[f.id] ?? const {}),
    ];
  }

  // 検索が空の時に出す「不足を補うおすすめ」の並び替え。
  //
  // 各食品の「1食分で、今足りていない微量栄養素をどれだけ満たせるか」を
  // (不足量を上限にして目標値で割った割合)の合計でスコア化し、高い順に並べる。
  // タグには、その食品が一番貢献する栄養素を表示する。
  List<RecommendedFood> rankByDeficit(
    List<FoodInfo> foods,
    NutritionTargets targets,
    NutrientAmounts eaten,
  ) {
    final remaining = <String, double>{
      for (final e in targets.micro.entries)
        e.key: (e.value - (eaten[e.key] ?? 0)).clamp(0, double.infinity),
    };

    final scored = <(RecommendedFood, double)>[];
    for (final info in foods) {
      var score = 0.0;
      String? bestKey;
      var bestContribution = 0.0;
      for (final e in targets.micro.entries) {
        final left = remaining[e.key] ?? 0;
        if (left <= 0) continue;
        final gained = info.perServing(e.key).clamp(0, left);
        final contribution = gained / e.value;
        score += contribution;
        if (contribution > bestContribution) {
          bestContribution = contribution;
          bestKey = e.key;
        }
      }

      String? tag;
      if (bestKey != null && bestContribution > 0.02) {
        final label = nutrientLabels[bestKey]!;
        final amount = info.perServing(bestKey);
        final amountText = amount >= 10
            ? amount.round().toString()
            : amount.toStringAsFixed(1);
        tag = '${label.$1} +$amountText${label.$2}';
      }
      scored.add((RecommendedFood(info: info, tag: tag), score));
    }

    scored.sort((a, b) => b.$2.compareTo(a.$2));
    return scored.map((e) => e.$1).toList();
  }

  // ---- 食事記録 ----

  // 指定した日の食事と合計摂取量。
  Future<DayIntake> loadDayIntake(DateTime day) async {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));

    final logs =
        await (db.select(db.mealLogs)
              ..where(
                (t) =>
                    t.eatenAt.isBiggerOrEqualValue(start) &
                    t.eatenAt.isSmallerThanValue(end),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.eatenAt)]))
            .get();

    if (logs.isEmpty) {
      return const DayIntake(totals: {}, meals: []);
    }

    final foods = {for (final f in await loadAllFoods()) f.food.id: f};
    final totals = <String, double>{};
    final meals = <MealEntry>[];

    for (final log in logs) {
      final itemRows = await (db.select(
        db.mealLogItems,
      )..where((t) => t.mealLogId.equals(log.id))).get();
      final views = <MealItemView>[];
      for (final item in itemRows) {
        final info = foods[item.foodId];
        if (info == null) continue;
        for (final key in nutrientLabels.keys) {
          totals[key] =
              (totals[key] ?? 0) + info.amountFor(key, item.quantityG);
        }
        views.add(
          MealItemView(
            name: info.food.name,
            quantityG: item.quantityG,
            kcal: info.amountFor('kcal', item.quantityG),
            p: info.amountFor('p', item.quantityG),
          ),
        );
      }
      meals.add(MealEntry(id: log.id, eatenAt: log.eatenAt, items: views));
    }

    return DayIntake(totals: totals, meals: meals);
  }

  Future<void> saveMeal(List<DraftItem> items, DateTime eatenAt) async {
    if (items.isEmpty) return;
    // ログ本体と中身を同時に保存する(途中で失敗して中身だけ欠ける、を防ぐ)。
    await db.transaction(() async {
      final logId = await db
          .into(db.mealLogs)
          .insert(MealLogsCompanion.insert(eatenAt: eatenAt));
      for (final item in items) {
        await db
            .into(db.mealLogItems)
            .insert(
              MealLogItemsCompanion.insert(
                mealLogId: logId,
                foodId: item.food.food.id,
                quantityG: item.quantityG,
              ),
            );
      }
    });
  }

  Future<void> deleteMeal(int mealLogId) async {
    await db.transaction(() async {
      await (db.delete(
        db.mealLogItems,
      )..where((t) => t.mealLogId.equals(mealLogId))).go();
      await (db.delete(db.mealLogs)..where((t) => t.id.equals(mealLogId))).go();
    });
  }

  // ---- 食事マイリスト ----

  Stream<List<MealList>> watchMealLists() => db.select(db.mealLists).watch();

  Future<List<DraftItem>> loadMealListItems(int listId) async {
    final foods = {for (final f in await loadAllFoods()) f.food.id: f};
    final rows =
        await (db.select(db.mealListItems)
              ..where((t) => t.listId.equals(listId))
              ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
            .get();
    return [
      for (final r in rows)
        if (foods[r.foodId] != null)
          DraftItem(food: foods[r.foodId]!, quantityG: r.quantityG),
    ];
  }

  Future<void> saveMealList(String name, List<DraftItem> items) async {
    if (items.isEmpty) return;
    await db.transaction(() async {
      final listId = await db
          .into(db.mealLists)
          .insert(MealListsCompanion.insert(name: name));
      for (var i = 0; i < items.length; i++) {
        await db
            .into(db.mealListItems)
            .insert(
              MealListItemsCompanion.insert(
                listId: listId,
                foodId: items[i].food.food.id,
                quantityG: items[i].quantityG,
                orderIndex: i,
              ),
            );
      }
    });
  }
}
