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
}
