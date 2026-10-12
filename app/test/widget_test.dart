// このファイルはFlutterの「ウィジェットテスト」の例。
// 実際に画面を組み立てて、ボタン操作などをシミュレートしながら
// 期待通りに動くかを確認できる。
//
// flutter create のテンプレートに入っていたカウンターアプリ用のテストを、
// 体重記録画面(WeightScreen)向けに書き換えている。

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/database/app_database.dart';
import 'package:fitness_app/main.dart';

void main() {
  testWidgets('体重を入力して記録すると一覧に表示される', (WidgetTester tester) async {
    // テスト用に、実ファイルを使わないインメモリのDBを用意する。
    // (drift の NativeDatabase.memory() を使うとファイルを作らずに済み、
    //  テストが端末の実データに影響を与えない)
    final database = AppDatabase.forTesting();

    await tester.pumpWidget(FitnessApp(database: database));
    // StreamBuilder は DB からの最初のデータが届くまで一瞬「読み込み中」の状態になる。
    // pump() で1フレーム進めて、Stream の最初の値(空の一覧)が反映されるのを待つ。
    await tester.pump();

    // ボトムナビの初期表示タブは「筋トレ」なので、まず「からだ」タブに切り替える。
    await tester.tap(find.widgetWithText(NavigationDestination, 'からだ'));
    await tester.pump();

    // 起動直後は「まだ記録がありません」と表示される想定。
    expect(find.text('まだ記録がありません'), findsOneWidget);

    // 体重の入力欄に「65.5」と入力する。
    await tester.enterText(find.widgetWithText(TextField, '体重 (kg) *必須'), '65.5');

    // 「記録する」ボタンをタップする。
    await tester.tap(find.text('記録する'));
    // pumpAndSettle で、保存処理やアニメーションが落ち着くまで待つ。
    await tester.pumpAndSettle();

    // 一覧に入力した体重が表示されているか確認する。
    expect(find.text('65.5 kg'), findsOneWidget);
    expect(find.text('まだ記録がありません'), findsNothing);

    // Drift の Stream(watch())は、購読解除された時に後片付け用のタイマーを
    // 一瞬だけ発生させる。テストが終わってウィジェットツリーが破棄される
    // タイミングでこれが起きると、flutter_test が「未処理のタイマーが残っている」
    // と判定してテストを失敗にしてしまう。
    // そのため、テストの最後で明示的にウィジェットツリーを空にして破棄を発生させ、
    // 実時間を少しだけ進める pump を挟んで、そのタイマーを確実に処理しきってから
    // DBを閉じる(この順番が重要: 先にウィジェットを破棄→pump→DBを閉じる)。
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await database.close();
  });

  testWidgets('種目を選んでトレーニングを終了すると履歴に残る', (WidgetTester tester) async {
    final database = AppDatabase.forTesting();
    // 種目選択画面が空では何も選べないので、本番と同じ初期データを入れておく。
    await database.seedExercisesIfEmpty();

    await tester.pumpWidget(FitnessApp(database: database));
    await tester.pump();

    // 初期表示タブは「筋トレ」。
    await tester.tap(find.text('＋ 種目を選んで記録する'));
    await tester.pumpAndSettle();

    // 種目選択画面で「ベンチプレス」を検索して選ぶ。
    await tester.enterText(find.byType(TextField), 'ベンチプレス');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'ベンチプレス'));
    await tester.pumpAndSettle();

    // セット記録画面に遷移し、種目名が表示されていることを確認。
    expect(find.text('ベンチプレス'), findsOneWidget);

    // 何も入力しないまま終了しても、セッションが履歴に記録されることを確認する。
    await tester.tap(find.text('トレーニングを終了'));
    await tester.pumpAndSettle();

    // 筋トレ画面に戻り、履歴に「ベンチプレス」のセッションが表示されるはず。
    expect(find.text('ベンチプレス'), findsOneWidget);
    expect(find.text('まだ記録がありません'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await database.close();
  });

  testWidgets('基本情報を入力して保存すると、再度開いた時も値が残っている', (WidgetTester tester) async {
    final database = AppDatabase.forTesting();

    await tester.pumpWidget(FitnessApp(database: database));
    await tester.pump();

    // ホームタブの設定ボタンから基本情報画面を開く。
    await tester.tap(find.widgetWithText(NavigationDestination, 'ホーム'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, '年齢'), '30');
    await tester.enterText(find.widgetWithText(TextField, '身長'), '175');
    await tester.enterText(find.widgetWithText(TextField, '体重'), '70');
    await tester.pump();

    // 入力に応じてサマリカードの目標摂取kcalが再計算されて表示されることを確認。
    expect(find.textContaining('kcal'), findsWidgets);

    await tester.tap(find.text('保存する').first);
    await tester.pumpAndSettle();
    expect(find.text('保存しました'), findsOneWidget);

    // 画面を出てから再度開き、入力した値が読み込まれることを確認する。
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField, '30'), findsOneWidget);
    expect(find.widgetWithText(TextField, '70'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await database.close();
  });
}
