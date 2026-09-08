import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// --- テーブル定義 ---
//
// Driftでは、テーブルを「Dartのクラス」として定義する。
// `Table` を継承したクラスの各ゲッター(get〜)が、そのままSQLの列(カラム)になる。
// これは docs/db-schema-draft.md の `body_measurements` テーブル設計に対応している。
//
// なぜ最初にこのテーブルから作るか:
// 体重・体脂肪率・筋肉量を記録するだけのシンプルな構造なので、
// 「画面 → DB保存 → 一覧表示」という一連の流れを最短で確認できるため。
// (docs/tech-stack-and-conventions.md で決めた「コードを学習教材として残す」方針に沿って、
//  あえて一番シンプルなテーブルから着手している)
class BodyMeasurements extends Table {
  // 主キー。autoIncrement() を付けると、保存するたびに自動で連番が振られる。
  IntColumn get id => integer().autoIncrement()();

  // 測定した日時。DateTime型で持たせておくと、後で「日付順に並べる」
  // 「期間で絞り込む」といった操作がしやすくなる。
  DateTimeColumn get measuredAt => dateTime()();

  // 体重(kg)。real() は小数を含む数値(浮動小数点数)を表す。
  RealColumn get weightKg => real()();

  // 体脂肪率(%)。nullable() にしているのは、体重だけ記録したい日にも
  // 対応できるようにするため(要件定義上、体脂肪率は必須項目ではない)。
  RealColumn get bodyFatPct => real().nullable()();

  // 筋肉量(kg)。こちらも同様に任意入力。
  RealColumn get muscleMassKg => real().nullable()();
}

// --- データベース本体 ---
//
// @DriftDatabase アノテーションは「このテーブル一覧を使ったDBクラスを生成して」という
// コード生成ツール(build_runner)への指示。
// `dart run build_runner build` を実行すると、テーブル操作用のコード
// (一覧取得・追加・削除などのメソッド群)を書き出した `app_database.g.dart` が
// 自動生成される。このファイル自体には手を加えない(生成物のため)。
@DriftDatabase(tables: [BodyMeasurements])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // テスト専用のコンストラクタ。
  // ファイルを作らずメモリ上だけでSQLiteを動かすので、テストを実行しても
  // 端末の実データ(fitness_app.sqlite)に影響を与えない。
  AppDatabase.forTesting() : super(NativeDatabase.memory());

  // スキーマ(テーブル構造)のバージョン。
  // 将来テーブル構造を変更する時は、この数字を上げてマイグレーション処理を追加する。
  @override
  int get schemaVersion => 1;
}

// --- DB接続の実体 ---
//
// LazyDatabase は「実際にDBへの操作が発生した瞬間」に接続を開く仕組み。
// アプリ起動時に毎回DBファイルを開きにいくと起動が遅くなるため、遅延させている。
//
// NativeDatabase は端末のローカルストレージにSQLiteのファイルとして保存する方式。
// これが要件定義で決めた「オフライン対応(ローカルファースト)」を実現している部分。
// クラウド同期(Supabase)は別のフェーズで追加する。
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'fitness_app.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
