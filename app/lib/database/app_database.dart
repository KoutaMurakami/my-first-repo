import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'exercise_seed.dart';

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

// --- 筋トレ記録まわりのテーブル ---
//
// docs/db-schema-draft.md の「1. 筋トレ記録」セクションに対応。
// まだ認証(Supabase)を実装していないフェーズなので、BodyMeasurements と同様に
// user_id は持たせていない(1台 = 1ユーザー前提のローカルDBとして扱う)。
// 認証を実装するタイミングで、各テーブルに userId を追加するマイグレーションを行う想定。

// 種目マスタ。
// 初期データは database/exercise_seed.dart から投入する(起動時に空なら流し込む方式)。
class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  // 部位。種目選択画面の部位チップ(すべて/胸/背中/脚/肩/腕/体幹)に合わせた分類。
  // docs/design/README.md の「種目選択」画面の仕様に準拠。
  TextColumn get bodyPart => text()();

  // ユーザーが「リストにない種目を手入力する」から追加した独自種目かどうか。
  // trueの種目は検索結果の末尾に出す、などの扱い分けに使う想定。
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
}

// 1回のトレーニングセッション(「開始」〜「終了」の単位)。
class WorkoutSessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get startedAt => dateTime()();

  // 終了していないセッション(中断中)は null のまま。
  DateTimeColumn get endedAt => dateTime().nullable()();

  // 'completed'(最後までやり切った) / 'aborted'(途中で終了した)。
  // endedAt がセットされて初めて意味を持つ値なので nullable にしている。
  TextColumn get status => text().nullable()();
}

// セットの「まとまり」。
//
// 通常セットも含めて全部このテーブルで管理する。理由は
// docs/db-schema-draft.md の相談ポイント①に書いた通りで、
// ドロップセット/ジャイアントセットのような複雑な構成を
// 「グループ化」という共通の仕組みで表現するため。
// groupType を増やすだけで新しいセット形式に対応できる。
class WorkoutSetGroups extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get sessionId =>
      integer().references(WorkoutSessions, #id)();

  // normal / drop_set / pyramid_set / giant_set / super_set
  TextColumn get groupType => text().withDefault(const Constant('normal'))();

  IntColumn get orderInSession => integer()();
}

// 実際に行った1セット。
class WorkoutSets extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get groupId =>
      integer().references(WorkoutSetGroups, #id)();

  IntColumn get exerciseId => integer().references(Exercises, #id)();

  IntColumn get orderInGroup => integer()();

  RealColumn get weightKg => real()();

  IntColumn get reps => integer()();

  IntColumn get restSeconds => integer().nullable()();

  // 完了チェック(セット記録画面の✓)。ドラフトのdb設計には無かった列だが、
  // 「未完了/完了」をUI・DB双方で扱うために実装上必要になったため追加。
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
}

// 補助レップ(フォーストレップ)の記録。
//
// 補助ありのセットは一部だけなので、全セットに毎回NULL列を持たせるより
// 「補助があったセットだけ1行追加する」設計にした
// (docs/db-schema-draft.md の補足を参照)。
class WorkoutSetAssists extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get setId => integer().references(WorkoutSets, #id)();

  // 'part'(最後の数回だけ補助) / 'full'(セット全体を補助)
  TextColumn get scope => text()();

  // scope='part' の時だけ使う、補助してもらった回数。
  IntColumn get assistedReps => integer().nullable()();

  // 'partner' / 'trainer' / 'self'(セルフ・片手補助)
  TextColumn get assistedBy => text()();

  TextColumn get memo => text().nullable()();
}

// マイトレリスト(よく使う種目の組み合わせ)。
class MyTrainingLists extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
}

// マイトレリストの中身(1種目ごとの行)。
class MyTrainingListItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get listId =>
      integer().references(MyTrainingLists, #id)();

  IntColumn get exerciseId => integer().references(Exercises, #id)();

  IntColumn get targetSets => integer()();

  // "6–10" のような範囲表記も扱えるよう、数値ではなく文字列で持たせる。
  TextColumn get targetReps => text()();

  IntColumn get orderIndex => integer()();

  // この種目をどのセット形式で行うか。マイトレ編集画面で変更できる。
  TextColumn get setType => text().withDefault(const Constant('ストレート'))();
}

// --- データベース本体 ---
//
// @DriftDatabase アノテーションは「このテーブル一覧を使ったDBクラスを生成して」という
// コード生成ツール(build_runner)への指示。
// `dart run build_runner build` を実行すると、テーブル操作用のコード
// (一覧取得・追加・削除などのメソッド群)を書き出した `app_database.g.dart` が
// 自動生成される。このファイル自体には手を加えない(生成物のため)。
@DriftDatabase(tables: [
  BodyMeasurements,
  Exercises,
  WorkoutSessions,
  WorkoutSetGroups,
  WorkoutSets,
  WorkoutSetAssists,
  MyTrainingLists,
  MyTrainingListItems,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // テスト専用のコンストラクタ。
  // ファイルを作らずメモリ上だけでSQLiteを動かすので、テストを実行しても
  // 端末の実データ(fitness_app.sqlite)に影響を与えない。
  AppDatabase.forTesting() : super(NativeDatabase.memory());

  // スキーマ(テーブル構造)のバージョン。
  // 将来テーブル構造を変更する時は、この数字を上げてマイグレーション処理を追加する。
  //
  // 1 → 2: 筋トレ記録一式(Exercises/WorkoutSessions/WorkoutSetGroups/WorkoutSets/
  //        WorkoutSetAssists/MyTrainingLists/MyTrainingListItems)を追加。
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          // アプリを初めて起動した端末では、全テーブルをこの時点のスキーマで作成する。
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          // 既にバージョン1(体重記録のみ)でアプリを使っていた場合、
          // 新しく追加したテーブルだけを作成する。
          if (from < 2) {
            await m.createTable(exercises);
            await m.createTable(workoutSessions);
            await m.createTable(workoutSetGroups);
            await m.createTable(workoutSets);
            await m.createTable(workoutSetAssists);
            await m.createTable(myTrainingLists);
            await m.createTable(myTrainingListItems);
          }
        },
      );

  // 種目マスタ(Exercises)が空なら、初期データ(exercise_seed.dart)を流し込む。
  // アプリ起動時に毎回呼んでも、2回目以降は「空かどうか」のチェックだけで
  // 早期リターンするので実害はない。
  Future<void> seedExercisesIfEmpty() async {
    final count = await (select(exercises)..limit(1)).get();
    if (count.isNotEmpty) return;

    await batch((b) {
      b.insertAll(
        exercises,
        [
          for (final (name, bodyPart) in exerciseSeedData)
            ExercisesCompanion.insert(name: name, bodyPart: bodyPart),
        ],
      );
    });
  }
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
