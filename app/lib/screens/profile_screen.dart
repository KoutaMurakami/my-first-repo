import 'package:drift/drift.dart' show OrderingTerm, Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../calc/nutrition_calc.dart';
import '../database/app_database.dart';
import 'split_editor_screen.dart';

// --- 基本情報(設定)画面 ---
//
// docs/design/README.md「11. 基本情報(設定)」に対応。
// 基礎代謝・TDEE・目標PFCの計算(calc/nutrition_calc.dart)に必要な入力項目を
// まとめて入力する画面。入力するたびにサマリカードをその場で再計算して見せる。
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.database});

  final AppDatabase database;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Profile? _profile;
  bool _loading = true;

  String _sex = 'male';
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _targetWeightController = TextEditingController();
  final _bodyFatController = TextEditingController();
  String _activityLevel = 'mid';
  String _goal = '体型維持';
  String _experience = '初心者';
  int _weeklyFreq = 3;
  bool _maintenanceManual = false;
  final _maintenanceManualController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    _bodyFatController.dispose();
    _maintenanceManualController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final db = widget.database;
    final profile = await db.loadOrCreateProfile();

    // 体重・体脂肪率が未入力なら、からだタブの最新記録を初期値として使う
    // (db-schema-draft.md の方針変更メモ: 計算用の「今の値」はprofiles側で持つが、
    //  初回はからだタブの記録を流用して入力の手間を減らす)。
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

    setState(() {
      _profile = profile;
      _sex = profile.sex;
      _ageController.text = profile.age?.toString() ?? '';
      _heightController.text = _fmt(profile.heightCm);
      _weightController.text = _fmt(weight);
      _targetWeightController.text = _fmt(profile.targetWeightKg);
      _bodyFatController.text = _fmt(bodyFat);
      _activityLevel = profile.activityLevel;
      _goal = profile.goal;
      _experience = profile.experienceLevel;
      _weeklyFreq = profile.weeklyFreq;
      _maintenanceManual = profile.maintenanceManual;
      _maintenanceManualController.text = _fmt(profile.maintenanceKcalManual);
      _loading = false;
    });
  }

  // 70.0 のように小数点以下が0の値は "70" と表示したいので、
  // 単純な toString() ではなく整数判定してから整形する。
  static String _fmt(double? v) {
    if (v == null) return '';
    return v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();
  }

  NutritionCalcResult get _result => calcNutrition(
        NutritionCalcInput(
          weightKg: double.tryParse(_weightController.text),
          heightCm: double.tryParse(_heightController.text),
          age: int.tryParse(_ageController.text),
          sex: _sex,
          bodyFatPct: double.tryParse(_bodyFatController.text),
          activityLevel: _activityLevel,
          goal: _goal,
          maintenanceManual: _maintenanceManual,
          maintenanceKcalManual: double.tryParse(_maintenanceManualController.text),
        ),
      );

  Future<void> _save() async {
    final profile = _profile;
    if (profile == null) return;

    await (widget.database.update(widget.database.profiles)
          ..where((t) => t.id.equals(profile.id)))
        .write(ProfilesCompanion(
      sex: Value(_sex),
      age: Value(int.tryParse(_ageController.text)),
      heightCm: Value(double.tryParse(_heightController.text)),
      weightKg: Value(double.tryParse(_weightController.text)),
      targetWeightKg: Value(double.tryParse(_targetWeightController.text)),
      bodyFatPct: Value(double.tryParse(_bodyFatController.text)),
      activityLevel: Value(_activityLevel),
      goal: Value(_goal),
      experienceLevel: Value(_experience),
      weeklyFreq: Value(_weeklyFreq),
      maintenanceManual: Value(_maintenanceManual),
      maintenanceKcalManual: Value(double.tryParse(_maintenanceManualController.text)),
    ));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('保存しました')),
      );
    }
  }

  Future<void> _editSplit() async {
    final profile = _profile;
    if (profile == null) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            SplitEditorScreen(database: widget.database, profileId: profile.id),
      ),
    );
    await _load(); // 分割法が変わったかもしれないので再読み込み
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final result = _result;

    return Scaffold(
      appBar: AppBar(
        title: const Text('基本情報'),
        actions: [
          TextButton(onPressed: _save, child: const Text('保存する')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SummaryCard(result: result),
          const SizedBox(height: 20),
          const Text('からだ', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'male', label: Text('男性')),
              ButtonSegment(value: 'female', label: Text('女性')),
            ],
            selected: {_sex},
            onSelectionChanged: (s) => setState(() => _sex = s.first),
          ),
          const SizedBox(height: 12),
          _numberField(_ageController, '年齢', suffix: '歳', integer: true),
          _numberField(_heightController, '身長', suffix: 'cm'),
          _numberField(_weightController, '体重', suffix: 'kg'),
          _numberField(_targetWeightController, '目標体重', suffix: 'kg'),
          _numberField(_bodyFatController, '体脂肪率(任意)', suffix: '%'),
          const SizedBox(height: 20),
          const Text('日頃の活動量', style: TextStyle(fontWeight: FontWeight.bold)),
          // RadioListTile単体の groupValue/onChanged はFlutter側で非推奨になったため、
          // 親の RadioGroup でまとめて選択状態を管理する新しいAPIに合わせている。
          RadioGroup<String>(
            groupValue: _activityLevel,
            onChanged: (v) => setState(() => _activityLevel = v!),
            child: Column(
              children: [
                for (final level in activityFactors.keys)
                  RadioListTile<String>(
                    value: level,
                    dense: true,
                    title: Text(
                      '${activityLevelLabels[level]} ×${activityFactors[level]}',
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text('トレーニング', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('目的', style: TextStyle(fontSize: 12, color: Colors.grey)),
          Wrap(
            spacing: 8,
            children: goalOptions
                .map((g) => ChoiceChip(
                      label: Text(g),
                      selected: _goal == g,
                      onSelected: (_) => setState(() => _goal = g),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          const Text('経験', style: TextStyle(fontSize: 12, color: Colors.grey)),
          Wrap(
            spacing: 8,
            children: experienceOptions
                .map((e) => ChoiceChip(
                      label: Text(e),
                      selected: _experience == e,
                      onSelected: (_) => setState(() => _experience = e),
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('週の回数'),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: _weeklyFreq > 1
                    ? () => setState(() => _weeklyFreq -= 1)
                    : null,
              ),
              Text('$_weeklyFreq回'),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: _weeklyFreq < 6
                    ? () => setState(() => _weeklyFreq += 1)
                    : null,
              ),
            ],
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('分割法'),
            subtitle: Text(_profile?.activeSplitId == null ? '未設定' : '設定済み'),
            trailing: FilledButton.tonal(
              onPressed: _editSplit,
              child: const Text('変更'),
            ),
          ),
          const SizedBox(height: 20),
          const Text('メンテナンスカロリー', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('自動計算値: ${result.tdeeAuto.round()}kcal',
              style: const TextStyle(color: Colors.grey)),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('実測値で上書きする'),
            value: _maintenanceManual,
            onChanged: (v) => setState(() => _maintenanceManual = v),
          ),
          if (_maintenanceManual)
            _numberField(_maintenanceManualController, '実測メンテナンスカロリー', suffix: 'kcal'),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: _save, child: const Text('保存する')),
          ),
        ],
      ),
    );
  }

  Widget _numberField(
    TextEditingController controller,
    String label, {
    String? suffix,
    bool integer = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: controller,
        keyboardType: integer
            ? TextInputType.number
            : const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
              integer ? RegExp(r'\d') : RegExp(r'[\d.]')),
        ],
        decoration: InputDecoration(labelText: label, suffixText: suffix),
        onChanged: (_) => setState(() {}),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.result});

  final NutritionCalcResult result;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _statTile('基礎代謝', '${result.bmr.round()}'),
                _statTile('メンテナンス', '${result.tdee.round()}'),
                _statTile('目標摂取', '${result.kcal}'),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '目標PFC  P ${result.proteinG}g / F ${result.fatG}g / C ${result.carbG}g',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(result.method,
                style: const TextStyle(fontSize: 11, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _statTile(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 11)),
          Text('$value kcal',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
