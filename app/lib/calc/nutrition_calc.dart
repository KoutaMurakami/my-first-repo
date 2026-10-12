// --- 基礎代謝・TDEE・目標PFCの計算 ---
//
// docs/design/Fitness App.dc.html の calc() をDartに移植したもの。
// (docs/design/README.md 「計算ロジック(JS calc()準拠)」に対応)
//
// 画面(ProfileScreen)から呼ぶ純粋関数として切り出している。
// 理由: この計算式自体はUIの都合と関係なく成立するロジックなので、
// 画面のStateクラスに埋め込むより別ファイルに出した方が、
// 「何を計算しているか」が追いやすく、後からテストもしやすい。

/// 計算に必要な入力値。未入力の項目はプロトタイプと同じデフォルト値で補う。
class NutritionCalcInput {
  const NutritionCalcInput({
    this.weightKg,
    this.heightCm,
    this.age,
    this.sex = 'male',
    this.bodyFatPct,
    this.activityLevel = 'mid',
    this.goal = '体型維持',
    this.maintenanceManual = false,
    this.maintenanceKcalManual,
  });

  final double? weightKg;
  final double? heightCm;
  final int? age;
  final String sex; // 'male' / 'female'
  final double? bodyFatPct;
  final String activityLevel; // low/light/mid/high/vhigh
  final String goal; // 減量/体型維持/筋肥大/筋力アップ
  final bool maintenanceManual;
  final double? maintenanceKcalManual;
}

/// 計算結果。
class NutritionCalcResult {
  const NutritionCalcResult({
    required this.weightKg,
    required this.bmr,
    required this.tdee,
    required this.tdeeAuto,
    required this.kcal,
    required this.proteinG,
    required this.fatG,
    required this.carbG,
    required this.method,
  });

  final double weightKg;
  final double bmr;
  final double tdee;
  final double tdeeAuto;
  final int kcal;
  final int proteinG;
  final int fatG;
  final int carbG;

  // どの計算式を使ったかの説明文(サマリカードの注記に表示する)。
  final String method;
}

const Map<String, double> activityFactors = {
  'low': 1.2,
  'light': 1.375,
  'mid': 1.55,
  'high': 1.725,
  'vhigh': 1.9,
};

const Map<String, String> activityLevelLabels = {
  'low': 'ほぼ座りっぱなし',
  'light': '軽い活動',
  'mid': '中程度',
  'high': '活発',
  'vhigh': '非常に活発',
};

const List<String> goalOptions = ['減量', '体型維持', '筋肥大', '筋力アップ'];
const List<String> experienceOptions = ['初心者', '中級', '上級'];

const Map<String, int> _goalKcalAdjust = {
  '減量': -400,
  '体型維持': 0,
  '筋肥大': 300,
  '筋力アップ': 200,
};

NutritionCalcResult calcNutrition(NutritionCalcInput input) {
  // プロトタイプと同じデフォルト値(未入力時の仮の体格)。
  final weight = input.weightKg ?? 72.4;
  final height = input.heightCm ?? 175;
  final age = input.age ?? 28;
  final bf = input.bodyFatPct;

  double bmr;
  String method;
  if (bf != null && bf > 3 && bf < 60) {
    // Katch-McArdle式: 除脂肪体重をもとに計算する(体脂肪率が分かっている時の方がより正確)。
    bmr = 370 + 21.6 * weight * (1 - bf / 100);
    method = 'Katch-McArdle式(体脂肪率を使用)× 活動係数で算出';
  } else {
    // Mifflin-St Jeor式: 体脂肪率が分からない時の標準的な簡易式。
    bmr = 10 * weight + 6.25 * height - 5 * age + (input.sex == 'male' ? 5 : -161);
    method = 'Mifflin-St Jeor式 × 活動係数で算出';
  }

  final factor = activityFactors[input.activityLevel] ?? activityFactors['mid']!;
  final tdeeAuto = bmr * factor;
  final tdee = input.maintenanceManual &&
          (input.maintenanceKcalManual ?? 0) > 800
      ? input.maintenanceKcalManual!
      : tdeeAuto;

  final adjust = _goalKcalAdjust[input.goal] ?? 0;
  final kcal = ((tdee + adjust) / 10).round() * 10;

  final protein = (weight * (input.goal == '減量' ? 2.2 : 2.0)).round();
  final fat = (kcal * 0.25 / 9).round();
  final carb = ((kcal - protein * 4 - fat * 9) / 4).round().clamp(0, 999999);

  return NutritionCalcResult(
    weightKg: weight,
    bmr: bmr,
    tdee: tdee,
    tdeeAuto: tdeeAuto,
    kcal: kcal,
    proteinG: protein,
    fatG: fat,
    carbG: carb,
    method: method,
  );
}
