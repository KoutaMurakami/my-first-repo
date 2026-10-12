import 'package:drift/drift.dart' show OrderingTerm, Value;
import 'package:flutter/material.dart';

import '../database/app_database.dart';

// 分割法エディタで選べる部位。筋トレ記録の6分類(胸/背中/脚/肩/腕/体幹)より細かい
// 8分類になっているのは、docs/design/README.md「11. 基本情報(設定)」の
// 分割法エディタの仕様(胸/背中/脚/肩/二頭/三頭/腹筋/臀部)に合わせたため。
const List<String> splitBodyParts = ['胸', '背中', '脚', '肩', '二頭', '三頭', '腹筋', '臀部'];

class _DayTemplate {
  const _DayTemplate(this.label, this.parts);
  final String label;
  final List<String> parts;
}

// docs/design/Fitness App.dc.html の splitPresets() をそのまま移植したもの。
const Map<String, List<_DayTemplate>> _presetTemplates = {
  '全身法': [_DayTemplate('全身', ['全身'])],
  '上下2分割': [
    _DayTemplate('上半身', ['胸', '背中', '肩', '二頭', '三頭']),
    _DayTemplate('下半身', ['脚', '臀部', '腹筋']),
  ],
  'PPL': [
    _DayTemplate('プッシュ', ['胸', '肩', '三頭']),
    _DayTemplate('プル', ['背中', '二頭']),
    _DayTemplate('レッグ', ['脚', '臀部']),
  ],
  '4分割': [
    _DayTemplate('', ['胸', '三頭']),
    _DayTemplate('', ['背中', '二頭']),
    _DayTemplate('', ['脚', '臀部']),
    _DayTemplate('', ['肩', '腹筋']),
  ],
  '5分割': [
    _DayTemplate('', ['胸']),
    _DayTemplate('', ['背中']),
    _DayTemplate('', ['脚']),
    _DayTemplate('', ['肩']),
    _DayTemplate('', ['二頭', '三頭']),
  ],
};

const Map<String, String> presetDescriptions = {
  '全身法': '毎回全身を鍛える。週2〜3回の初心者や時間が少ない人向け。',
  '上下2分割': '上半身と下半身を交互に。週4回前後で回しやすい。',
  'PPL': '押す・引く・脚の3分割。週3〜6回で回せる定番。',
  '4分割': '部位を4日に分けて1部位あたりのボリュームを増やす。',
  '5分割': '1日1部位に集中する上級者向け。各日の部位は自由に変更できます。',
  'カスタム': '日数も部位も自由に組めます。',
};

const List<String> presetOptions = ['全身法', '上下2分割', 'PPL', '4分割', '5分割', 'カスタム'];

class _DayState {
  _DayState({this.label, required this.parts});
  String? label;
  List<String> parts;

  String get displayLabel {
    if (label != null && label!.isNotEmpty) return label!;
    if (parts.isNotEmpty) return parts.join('・');
    return '未設定';
  }
}

// --- 分割法エディタ ---
//
// docs/design/README.md「11. 基本情報(設定)」の分割法エディタに対応。
// 基本情報画面・筋トレ画面の両方から呼べる共通コンポーネントにする、という
// 設計意図に合わせて、独立した画面(プッシュ遷移)として実装している。
class SplitEditorScreen extends StatefulWidget {
  const SplitEditorScreen({
    super.key,
    required this.database,
    required this.profileId,
  });

  final AppDatabase database;
  final int profileId;

  @override
  State<SplitEditorScreen> createState() => _SplitEditorScreenState();
}

class _SplitEditorScreenState extends State<SplitEditorScreen> {
  String _preset = 'PPL';
  List<_DayState> _days = _presetTemplates['PPL']!
      .map((t) => _DayState(label: t.label, parts: List.of(t.parts)))
      .toList();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = widget.database;
    final profile = await (db.select(db.profiles)
          ..where((t) => t.id.equals(widget.profileId)))
        .getSingleOrNull();
    final splitId = profile?.activeSplitId;

    if (splitId != null) {
      final split = await (db.select(db.trainingSplits)
            ..where((t) => t.id.equals(splitId)))
          .getSingleOrNull();
      if (split != null) {
        final dayRows = await (db.select(db.splitDays)
              ..where((t) => t.splitId.equals(splitId))
              ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
            .get();
        final days = <_DayState>[];
        for (final d in dayRows) {
          final partRows = await (db.select(db.splitDayParts)
                ..where((t) => t.splitDayId.equals(d.id)))
              .get();
          days.add(_DayState(
            label: d.label,
            parts: partRows.map((p) => p.bodyPart).toList(),
          ));
        }
        if (days.isNotEmpty) {
          setState(() {
            _preset = split.preset;
            _days = days;
          });
        }
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  void _applyPreset(String preset) {
    setState(() {
      _preset = preset;
      if (preset == 'カスタム') {
        _days = [_DayState(label: null, parts: [])];
      } else {
        _days = _presetTemplates[preset]!
            .map((t) => _DayState(label: t.label, parts: List.of(t.parts)))
            .toList();
      }
    });
  }

  Future<void> _editDayParts(int index) async {
    final selected = Set<String>.of(_days[index].parts);
    final result = await showModalBottomSheet<Set<String>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('部位を編集', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: splitBodyParts
                        .map(
                          (part) => FilterChip(
                            label: Text(part),
                            selected: selected.contains(part),
                            onSelected: (v) => setSheetState(() {
                              if (v) {
                                selected.add(part);
                              } else {
                                selected.remove(part);
                              }
                            }),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context, selected),
                      child: const Text('決定'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _days[index].parts = result.toList();
        // 部位を編集したら、プリセット由来の固定ラベルは外し、
        // 部位名の連結表示(displayLabel)に切り替える(README仕様通り)。
        _days[index].label = null;
      });
    }
  }

  void _addDay() {
    if (_days.length >= 7) return;
    setState(() => _days.add(_DayState(label: null, parts: [])));
  }

  void _removeLastDay() {
    if (_days.length <= 1) return;
    setState(() => _days.removeLast());
  }

  Future<void> _save() async {
    final db = widget.database;

    // 既存の分割法が無ければ新規作成、あれば中身を入れ替える
    // (差分更新ではなく、一度消して作り直す単純な方式にしている)。
    final profile = await (db.select(db.profiles)
          ..where((t) => t.id.equals(widget.profileId)))
        .getSingle();

    int splitId;
    if (profile.activeSplitId != null) {
      splitId = profile.activeSplitId!;
      await (db.update(db.trainingSplits)..where((t) => t.id.equals(splitId)))
          .write(TrainingSplitsCompanion(preset: Value(_preset)));

      final oldDays = await (db.select(db.splitDays)
            ..where((t) => t.splitId.equals(splitId)))
          .get();
      for (final d in oldDays) {
        await (db.delete(db.splitDayParts)
              ..where((t) => t.splitDayId.equals(d.id)))
            .go();
      }
      await (db.delete(db.splitDays)..where((t) => t.splitId.equals(splitId)))
          .go();
    } else {
      splitId = await db.into(db.trainingSplits).insert(
            TrainingSplitsCompanion.insert(preset: _preset),
          );
      await (db.update(db.profiles)..where((t) => t.id.equals(widget.profileId)))
          .write(ProfilesCompanion(activeSplitId: Value(splitId)));
    }

    for (var i = 0; i < _days.length; i++) {
      final day = _days[i];
      final dayId = await db.into(db.splitDays).insert(
            SplitDaysCompanion.insert(
              splitId: splitId,
              orderIndex: i,
              label: Value(day.label),
            ),
          );
      for (final part in day.parts) {
        await db.into(db.splitDayParts).insert(
              SplitDayPartsCompanion.insert(splitDayId: dayId, bodyPart: part),
            );
      }
    }

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('分割法を編集'),
        actions: [
          TextButton(onPressed: _save, child: const Text('保存する')),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: presetOptions
                      .map(
                        (p) => ChoiceChip(
                          label: Text(p),
                          selected: _preset == p,
                          onSelected: (_) => _applyPreset(p),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 8),
                Text(
                  presetDescriptions[_preset] ?? '',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                for (var i = 0; i < _days.length; i++)
                  Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text('Day ${i + 1}  ${_days[i].displayLabel}'),
                      trailing: TextButton(
                        onPressed: () => _editDayParts(i),
                        child: const Text('部位を編集'),
                      ),
                    ),
                  ),
                if (_preset == 'カスタム')
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _days.length < 7 ? _addDay : null,
                          child: const Text('＋ 日を追加'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _days.length > 1 ? _removeLastDay : null,
                          child: const Text('− 最後の日を削除'),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
    );
  }
}
