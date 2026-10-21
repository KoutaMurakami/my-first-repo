import 'package:flutter/material.dart';

import 'database/app_database.dart';
import 'screens/home_screen.dart';
import 'screens/meal_screen.dart';
import 'screens/my_training_list_screen.dart';
import 'screens/weight_screen.dart';
import 'screens/workout_home_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  // プラグイン(path_providerなど)を使う前に必要な初期化。
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();
  // 種目マスタが空(=初回起動)なら、初期データを流し込んでおく。
  await database.seedExercisesIfEmpty();
  await database.seedFoodsIfEmpty();

  runApp(FitnessApp(database: database));
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
      theme: buildAppTheme(),
      home: HomeShell(database: database),
    );
  }
}

// --- ボトムナビゲーションの土台 ---
//
// docs/design/README.md の「共通レイアウト」にある5タブ構成
// (ホーム / マイトレ / 筋トレ / 食事 / からだ)をそのまま採用している。
// 起動時はホームを表示し、ホームの体重カードから「からだ」タブへ移動できる。
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.database});

  final AppDatabase database;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0; // 初期タブは「ホーム」

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeScreen(
        database: widget.database,
        onOpenBody: () => setState(() => _index = 4),
      ),
      MyTrainingListScreen(database: widget.database),
      WorkoutHomeScreen(database: widget.database),
      MealScreen(database: widget.database),
      WeightScreen(database: widget.database),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'ホーム'),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            label: 'マイトレ',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            label: '筋トレ',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_outlined),
            label: '食事',
          ),
          NavigationDestination(
            icon: Icon(Icons.monitor_weight_outlined),
            label: 'からだ',
          ),
        ],
      ),
    );
  }
}
