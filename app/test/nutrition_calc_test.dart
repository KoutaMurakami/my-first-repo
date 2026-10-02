// nutrition_calc.dart は画面を介さない純粋関数なので、ウィジェットテストより
// 素早く確実に検証できるユニットテストとして書く。
//
// 期待値は docs/design/Fitness App.dc.html の calc() と同じ式を手計算して求めたもの。

import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/calc/nutrition_calc.dart';

void main() {
  test('体脂肪率なし(Mifflin-St Jeor式)・体型維持', () {
    final result = calcNutrition(const NutritionCalcInput(
      weightKg: 70,
      heightCm: 175,
      age: 30,
      sex: 'male',
      activityLevel: 'mid',
      goal: '体型維持',
    ));

    // bmr = 10*70 + 6.25*175 - 5*30 + 5 = 1648.75
    expect(result.bmr, closeTo(1648.75, 0.01));
    // tdeeAuto = bmr * 1.55 = 2555.5625
    expect(result.tdeeAuto, closeTo(2555.5625, 0.01));
    expect(result.kcal, 2560); // 10kcal単位に丸め
    expect(result.proteinG, 140); // 70 * 2.0
    expect(result.fatG, 71); // round(2560*0.25/9)
    expect(result.carbG, 340);
    expect(result.method, contains('Mifflin-St Jeor'));
  });

  test('体脂肪率あり(Katch-McArdle式)・減量目的', () {
    final result = calcNutrition(const NutritionCalcInput(
      weightKg: 70,
      bodyFatPct: 20,
      activityLevel: 'mid',
      goal: '減量',
    ));

    // bmr = 370 + 21.6*70*(1-0.2) = 1579.6
    expect(result.bmr, closeTo(1579.6, 0.01));
    expect(result.kcal, 2050); // tdeeAuto(2448.38) - 400 を10kcal単位に丸め
    expect(result.proteinG, 154); // 70 * 2.2(減量時)
    expect(result.fatG, 57);
    expect(result.carbG, 230);
    expect(result.method, contains('Katch-McArdle'));
  });

  test('メンテナンスカロリーを実測値で上書きできる', () {
    final result = calcNutrition(const NutritionCalcInput(
      weightKg: 70,
      heightCm: 175,
      age: 30,
      maintenanceManual: true,
      maintenanceKcalManual: 2200,
      goal: '体型維持',
    ));

    expect(result.tdee, 2200);
    expect(result.kcal, 2200);
  });
}
