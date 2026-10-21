import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../data/meal_repository.dart';
import '../data/nutrition_targets.dart';

// --- 「今日の残り」カード ---
//
// 食事画面・食事記録画面(・今後のホーム画面)で共通して使う、
// カロリーとPFC、不足している微量栄養素をまとめたカード。
// docs/design/README.md「1. ホーム」「6. 食事」「7. 食事を記録」の共通UIに対応。
//
// [eaten] には「すでに食べた分」を渡す。食事記録画面では
// 「食べた分 + これから記録する分(ドラフト)」を渡すことで、
// 記録後の残りをその場でプレビューできる。
// PFCそれぞれのバーの色(docs/design/README.md のカラートークン)。
const Map<String, Color> _macroColors = {
  'p': AppColors.primary,
  'f': AppColors.meal,
  'c': AppColors.carbs,
};

class RemainingCard extends StatelessWidget {
  const RemainingCard({
    super.key,
    required this.title,
    required this.targets,
    required this.eaten,
    this.showBurn = false,
    this.onRecordMeal,
  });

  final String title;
  final NutritionTargets targets;
  final NutrientAmounts eaten;

  // true の時は、残りの大きな数字の代わりに「摂取 / 消費 / 残り」の3つ並びで表示する(ホーム画面用)。
  final bool showBurn;

  // 指定すると、カード下部に「不足を補う食事を記録」ボタンを出す。
  final VoidCallback? onRecordMeal;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final eatenKcal = eaten['kcal'] ?? 0;
    final leftKcal = targets.kcal - eatenKcal;
    final progress = targets.kcal <= 0
        ? 0.0
        : (eatenKcal / targets.kcal).clamp(0.0, 1.0);

    // 充足率が低い順に最大5件。
    final micros = targets.micro.entries.map((e) {
      final got = eaten[e.key] ?? 0;
      return (key: e.key, target: e.value, got: got, ratio: got / e.value);
    }).toList()..sort((a, b) => a.ratio.compareTo(b.ratio));
    final shownMicros = micros.take(5).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (showBurn)
              Row(
                children: [
                  _tile('摂取', eatenKcal, scheme.tertiary),
                  _tile('消費(予測)', targets.tdee, scheme.onPrimaryContainer),
                  _tile('残り', leftKcal, leftKcal >= 0 ? null : scheme.error),
                ],
              )
            else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    leftKcal >= 0
                        ? '残り ${leftKcal.round()}'
                        : '超過 ${(-leftKcal).round()}',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: leftKcal >= 0 ? null : scheme.error,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text('kcal'),
                  const Spacer(),
                  Text(
                    '摂取 ${eatenKcal.round()} / 目標 ${targets.kcal.round()}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textTertiary),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(value: progress, minHeight: 6),
            ],
            const SizedBox(height: 14),
            _macroRow(context, 'たんぱく質', 'p'),
            _macroRow(context, '脂質', 'f'),
            _macroRow(context, '炭水化物', 'c'),
            const Divider(height: 24),
            const Text(
              '不足している栄養素',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            for (final m in shownMicros) _microRow(context, m),
            if (onRecordMeal != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: scheme.tertiary,
                    foregroundColor: scheme.onTertiary,
                  ),
                  onPressed: onRecordMeal,
                  child: const Text('不足を補う食事を記録'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tile(String label, double value, Color? color) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
          Text(
            value.round().toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const Text(
            'kcal',
            style: TextStyle(fontSize: 10, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _macroRow(BuildContext context, String label, String key) {
    final scheme = Theme.of(context).colorScheme;
    final target = targets.of(key);
    final got = eaten[key] ?? 0;
    final left = target - got;
    final String leftText;
    Color? leftColor;
    if (left > 0.5) {
      leftText = 'あと ${left.round()}g';
    } else if (left < -3) {
      leftText = '${(-left).round()}g 超過';
      leftColor = scheme.error;
    } else {
      leftText = '達成';
      leftColor = scheme.primary;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(label, style: const TextStyle(fontSize: 13)),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: target <= 0 ? 0 : (got / target).clamp(0.0, 1.0),
              minHeight: 6,
              // PFCの色分け: たんぱく質=深緑 / 脂質=テラコッタ / 炭水化物=オリーブ
              color: _macroColors[key],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 120,
            child: Text(
              '$leftText  ${got.round()}/${target.round()}g',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 12, color: leftColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _microRow(
    BuildContext context,
    ({String key, double target, double got, double ratio}) m,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final label = nutrientLabels[m.key]!;
    final left = m.target - m.got;
    final amount = m.target >= 50
        ? left.round().toString()
        : left.toStringAsFixed(1);
    final low = m.ratio < 0.5;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 84,
            child: Text(label.$1, style: const TextStyle(fontSize: 13)),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: m.ratio.clamp(0.0, 1.0),
              minHeight: 6,
              color: low ? scheme.tertiary : null,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 86,
            child: Text(
              left > 0 ? 'あと $amount${label.$2}' : '達成',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                color: low ? scheme.tertiary : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
