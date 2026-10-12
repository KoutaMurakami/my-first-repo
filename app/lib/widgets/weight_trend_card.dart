import 'package:flutter/material.dart';

import '../database/app_database.dart';

// 体重推移カードで切り替えられる表示期間。(ラベル, 日数)
const List<(String label, int days)> _periods = [
  ('1週', 7),
  ('1ヶ月', 30),
  ('3ヶ月', 90),
];

// --- 体重の推移カード(ホーム画面) ---
//
// docs/design/README.md「1. ホーム」の「体重の推移カード」に対応。
// 期間(1週/1ヶ月/3ヶ月)を切り替えながら、体重の折れ線グラフ・増減・目標までの残りを表示する。
//
// グラフ用のパッケージは追加せず、CustomPainter で自前描画している。
// 理由: 折れ線+塗りだけの単純なグラフなので、依存パッケージを増やすより
// 描画の仕組みを自分で追える方が、このリポジトリの「理解できるコード」という方針に合うため。
class WeightTrendCard extends StatefulWidget {
  const WeightTrendCard({
    super.key,
    required this.measurements,
    required this.targetWeightKg,
    required this.onTap,
    this.now,
  });

  // 体重記録の全件(順不同でよい)。期間での絞り込みはこのカード内で行う。
  final List<BodyMeasurement> measurements;
  final double? targetWeightKg;
  final VoidCallback onTap;

  // 「今日」の基準。テストで日付を固定するために差し替えられるようにしている。
  final DateTime? now;

  @override
  State<WeightTrendCard> createState() => _WeightTrendCardState();
}

class _WeightTrendCardState extends State<WeightTrendCard> {
  int _periodIndex = 1; // 初期は「1ヶ月」

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final now = widget.now ?? DateTime.now();

    final all = [...widget.measurements]
      ..sort((a, b) => a.measuredAt.compareTo(b.measuredAt));
    final latest = all.isEmpty ? null : all.last;

    final since = now.subtract(Duration(days: _periods[_periodIndex].$2));
    final inPeriod = all.where((m) => !m.measuredAt.isBefore(since)).toList();

    // 増減 = 期間内の最初の記録 → 最新の記録。期間内に2件以上ある時だけ出す。
    double? delta;
    if (inPeriod.length >= 2) {
      delta = inPeriod.last.weightKg - inPeriod.first.weightKg;
    }

    final target = widget.targetWeightKg;
    String? goalText;
    if (latest != null && target != null) {
      final diff = latest.weightKg - target;
      goalText = diff.abs() < 0.05
          ? '目標 ${_fmt(target)}kg 達成'
          : '目標 ${_fmt(target)}kg まで あと ${_fmt(diff.abs())}kg';
    }

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    '体重の推移',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  SegmentedButton<int>(
                    showSelectedIcon: false,
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      textStyle: WidgetStatePropertyAll(
                        TextStyle(fontSize: 11),
                      ),
                    ),
                    segments: [
                      for (var i = 0; i < _periods.length; i++)
                        ButtonSegment(value: i, label: Text(_periods[i].$1)),
                    ],
                    selected: {_periodIndex},
                    onSelectionChanged: (s) =>
                        setState(() => _periodIndex = s.first),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (latest == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      '体重を記録するとここに推移が表示されます',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _fmt(latest.weightKg),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text('kg'),
                    const SizedBox(width: 10),
                    if (delta != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.primaryContainer,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          '${delta < 0 ? '−' : '+'}${_fmt(delta.abs())}kg',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: scheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 70,
                  width: double.infinity,
                  child: inPeriod.isEmpty
                      ? const Center(
                          child: Text(
                            'この期間の記録がありません',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        )
                      : CustomPaint(
                          painter: _WeightChartPainter(
                            values: [for (final m in inPeriod) m.weightKg],
                            times: [
                              for (final m in inPeriod)
                                m.measuredAt.millisecondsSinceEpoch.toDouble(),
                            ],
                            lineColor: scheme.primary,
                            fillColor: scheme.primary.withValues(alpha: 0.12),
                          ),
                        ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      inPeriod.isEmpty
                          ? ''
                          : '${inPeriod.first.measuredAt.month}/${inPeriod.first.measuredAt.day}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    if (goalText != null)
                      Text(
                        goalText,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const Text(
                      '今日',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // 70.0 → "70"、70.4 → "70.4"
  static String _fmt(double v) {
    final rounded = (v * 10).round() / 10;
    return rounded == rounded.roundToDouble()
        ? rounded.toStringAsFixed(0)
        : rounded.toString();
  }
}

// 折れ線+塗りのグラフを描く。
class _WeightChartPainter extends CustomPainter {
  _WeightChartPainter({
    required this.values,
    required this.times,
    required this.lineColor,
    required this.fillColor,
  });

  final List<double> values;
  final List<double> times;
  final Color lineColor;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    const padding = 8.0;
    final w = size.width - padding * 2;
    final h = size.height - padding * 2;

    var minV = values.reduce((a, b) => a < b ? a : b);
    var maxV = values.reduce((a, b) => a > b ? a : b);
    // 値がほぼ一定でも線が潰れないよう、上下に少し余白(幅)を持たせる。
    if (maxV - minV < 0.5) {
      minV -= 0.25;
      maxV += 0.25;
    }
    final minT = times.first;
    final maxT = times.last;

    Offset pointAt(int i) {
      // 記録が1件だけ(時間幅が0)の時は中央に置く。
      final x = maxT == minT
          ? padding + w / 2
          : padding + (times[i] - minT) / (maxT - minT) * w;
      final y = padding + (1 - (values[i] - minV) / (maxV - minV)) * h;
      return Offset(x, y);
    }

    final points = [for (var i = 0; i < values.length; i++) pointAt(i)];

    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      line.lineTo(p.dx, p.dy);
    }

    final area = Path.from(line)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();
    canvas.drawPath(area, Paint()..color = fillColor);

    canvas.drawPath(
      line,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round,
    );

    // 最新の点だけ強調する。
    canvas.drawCircle(points.last, 5, Paint()..color = lineColor);
  }

  @override
  bool shouldRepaint(covariant _WeightChartPainter old) =>
      old.values != values || old.times != times;
}
