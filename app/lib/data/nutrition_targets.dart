import 'package:drift/drift.dart' show OrderingTerm;

import '../calc/nutrition_calc.dart';
import '../database/app_database.dart';

// 微量栄養素の1日あたり目標値。
// docs/design/Fitness App.dc.html の nutrition() 内の T0 のうち、
// 現在の食品データ(food_seed.dart)が持っている4種類だけを取り出したもの。
// 残りの栄養素は、食品データ側に栄養素を追加した時にここへ足す。
const Map<String, double> microTargets = {
  'ca': 650,
  'vc': 100,
  'fe': 7.5,
  'fib': 21,
};

// 画面表示用の名前と単位。(コード → (表示名, 単位))
const Map<String, (String name, String unit)> nutrientLabels = {
  'kcal': ('エネルギー', 'kcal'),
  'p': ('たんぱく質', 'g'),
  'f': ('脂質', 'g'),
  'c': ('炭水化物', 'g'),
  'ca': ('カルシウム', 'mg'),
  'vc': ('ビタミンC', 'mg'),
  'fe': ('鉄', 'mg'),
  'fib': ('食物繊維', 'g'),
};

// 1日の栄養目標(エネルギー・PFCは基本情報から計算、微量栄養素は固定値)。
class NutritionTargets {
  const NutritionTargets({
    required this.kcal,
    required this.p,
    required this.f,
    required this.c,
    required this.micro,
  });

  final double kcal;
  final double p;
  final double f;
  final double c;
  final Map<String, double> micro;

  // 栄養素コードから目標値を引く。
  double of(String key) {
    switch (key) {
      case 'kcal':
        return kcal;
      case 'p':
        return p;
      case 'f':
        return f;
      case 'c':
        return c;
      default:
        return micro[key] ?? 0;
    }
  }
}

// 基本情報(Profiles)から目標摂取量を計算して返す。
//
// 体重・体脂肪率が基本情報で未入力の場合は、からだタブの最新記録で補う
// (ProfileScreenの初期値と同じ考え方)。どちらも無ければ calcNutrition 側の
// デフォルト体格で計算される。
Future<NutritionTargets> loadTargets(AppDatabase db) async {
  final profile = await db.loadOrCreateProfile();

  double? weight = profile.weightKg;
  double? bodyFat = profile.bodyFatPct;
  if (weight == null || bodyFat == null) {
    final latest = await (db.select(db.bodyMeasurements)
          ..orderBy([(t) => OrderingTerm.desc(t.measuredAt)])
          ..limit(1))
        .getSingleOrNull();
    weight ??= latest?.weightKg;
    bodyFat ??= latest?.bodyFatPct;
  }

  final result = calcNutrition(NutritionCalcInput(
    weightKg: weight,
    heightCm: profile.heightCm,
    age: profile.age,
    sex: profile.sex,
    bodyFatPct: bodyFat,
    activityLevel: profile.activityLevel,
    goal: profile.goal,
    maintenanceManual: profile.maintenanceManual,
    maintenanceKcalManual: profile.maintenanceKcalManual,
  ));

  return NutritionTargets(
    kcal: result.kcal.toDouble(),
    p: result.proteinG.toDouble(),
    f: result.fatG.toDouble(),
    c: result.carbG.toDouble(),
    micro: microTargets,
  );
}
