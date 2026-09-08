import 'package:drift/drift.dart' show OrderingTerm, Value;
import 'package:flutter/material.dart';

import '../database/app_database.dart';

// --- 体重記録画面 ---
//
// この画面は「入力フォーム」と「記録一覧」の2つで構成されるシンプルな画面。
// 目的は、今回の実装の第一歩として、Flutterアプリ全体の流れ
// (画面入力 → Driftでローカル保存 → 画面に反映)を一通り動かして確認すること。
class WeightScreen extends StatefulWidget {
  // AppDatabase を外から受け取る(コンストラクタで渡す)ようにしている。
  // こうしておくと、この画面が「どのDBを使うか」を自分で決め打ちせずに済み、
  // 後でテスト用のDBに差し替えたりする時にも柔軟に対応できる。
  const WeightScreen({super.key, required this.database});

  final AppDatabase database;

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  // フォームの入力値を扱うためのコントローラー。
  // TextEditingController は「テキスト入力欄の今の中身」を保持・監視するためのクラス。
  final _weightController = TextEditingController();
  final _bodyFatController = TextEditingController();
  final _muscleMassController = TextEditingController();

  @override
  void dispose() {
    // 画面が破棄される時にコントローラーも一緒に破棄する。
    // これを忘れるとメモリリーク(使われなくなったオブジェクトが残り続ける)の原因になる。
    _weightController.dispose();
    _bodyFatController.dispose();
    _muscleMassController.dispose();
    super.dispose();
  }

  // 「記録する」ボタンが押された時の処理。
  Future<void> _saveMeasurement() async {
    final weightText = _weightController.text.trim();
    if (weightText.isEmpty) {
      // 体重は必須項目(要件定義どおり)。未入力ならここで止める。
      return;
    }

    final weight = double.tryParse(weightText);
    if (weight == null) {
      return;
    }

    // 体脂肪率・筋肉量は任意項目なので、未入力なら null のまま保存する。
    final bodyFat = double.tryParse(_bodyFatController.text.trim());
    final muscleMass = double.tryParse(_muscleMassController.text.trim());

    // Driftが自動生成した companion クラス(BodyMeasurementsCompanion)を使って
    // 1行分のデータを組み立て、into().insert() でテーブルに追加する。
    // Value(...) で包むのは「この値を明示的に指定する」という意味
    // (nullを渡すのと「指定しない」を区別するためのDrift独自の仕組み)。
    await widget.database.into(widget.database.bodyMeasurements).insert(
          BodyMeasurementsCompanion.insert(
            measuredAt: DateTime.now(),
            weightKg: weight,
            bodyFatPct: Value(bodyFat),
            muscleMassKg: Value(muscleMass),
          ),
        );

    // 保存できたら入力欄をクリアする。
    _weightController.clear();
    _bodyFatController.clear();
    _muscleMassController.clear();

    // setState は「画面を再描画して」という指示。
    // 一覧表示は StreamBuilder(下記)が自動で更新するので、ここでは
    // 入力欄をクリアしたことを画面に反映させるためだけに呼んでいる。
    setState(() {});
  }

  Future<void> _deleteMeasurement(int id) async {
    await (widget.database.delete(widget.database.bodyMeasurements)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('体重記録')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _weightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: '体重 (kg) *必須',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _bodyFatController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: '体脂肪率 (%)',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _muscleMassController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: '筋肉量 (kg)',
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _saveMeasurement,
                    child: const Text('記録する'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            // StreamBuilder は「DBの中身が変わるたびに自動で再描画してくれる」ウィジェット。
            // watch() が返すのは「変更を監視できるStream」で、
            // insert/deleteのたびにDriftが自動で新しい一覧を流してくれる。
            // これにより、setStateを手動で呼ばなくても一覧表示が常に最新の状態になる。
            child: StreamBuilder<List<BodyMeasurement>>(
              stream: (widget.database.select(widget.database.bodyMeasurements)
                    ..orderBy([
                      (tbl) => OrderingTerm.desc(tbl.measuredAt),
                    ]))
                  .watch(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final measurements = snapshot.data!;
                if (measurements.isEmpty) {
                  return const Center(child: Text('まだ記録がありません'));
                }
                return ListView.builder(
                  itemCount: measurements.length,
                  itemBuilder: (context, index) {
                    final m = measurements[index];
                    final subtitleParts = <String>[
                      if (m.bodyFatPct != null) '体脂肪率 ${m.bodyFatPct}%',
                      if (m.muscleMassKg != null) '筋肉量 ${m.muscleMassKg}kg',
                    ];
                    return ListTile(
                      title: Text('${m.weightKg} kg'),
                      subtitle: subtitleParts.isEmpty
                          ? null
                          : Text(subtitleParts.join(' / ')),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _deleteMeasurement(m.id),
                      ),
                      leading: Text(
                        '${m.measuredAt.month}/${m.measuredAt.day}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
