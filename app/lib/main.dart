import 'package:flutter/material.dart';

import 'database/app_database.dart';
import 'screens/weight_screen.dart';

void main() {
  runApp(FitnessApp(database: AppDatabase()));
}

// --- アプリのルート ---
//
// AppDatabase のインスタンスをここで1つだけ作り、下の画面に渡す。
// 「アプリ全体で同じDB接続を使い回す」ことが重要なので、
// 画面ごとに new AppDatabase() すると接続がバラバラになってしまい、
// 保存した内容が別画面に反映されない、といった不具合の原因になる。
// (将来、画面が増えてきたら Provider などの状態管理パッケージ経由で
//  渡す形に整理する想定。今はシンプルにコンストラクタで渡している)
class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'フィットネス管理アプリ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: WeightScreen(database: database),
    );
  }
}
