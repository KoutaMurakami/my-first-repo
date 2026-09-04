# DB設計(叩き台)

`docs/requirements-fitness-app.md` の内容を元にした、テーブル構造の初期設計案。
`docs/tech-stack-and-conventions.md` で決めた通り、ローカル(Drift/SQLite)・クラウド(Supabase/PostgreSQL)ともに同じテーブル構造を基本とする想定。

- 作成日: 2026年8月
- ステータス: レビュー待ちの叩き台(未確定)

## 0. 認証・ユーザー

Supabaseには標準で `auth.users`(メールアドレス・パスワード管理などを担う認証専用テーブル)が用意されているので、それをそのまま利用する。アプリ独自のユーザー情報は別テーブルに分離する。

- **なぜ分けるか**: 認証情報(パスワード等)とアプリ固有情報(身長・目標など)を同じテーブルに混ぜると、責務が曖昧になりセキュリティ的にも良くない。「認証は認証、プロフィールはプロフィール」と分離するのはDB設計の基本パターン。

```
profiles
- user_id (PK, auth.usersのidと1:1)
- display_name
- height_cm
- birth_date
- goal (bulk/cut/maintain など)
- created_at
```

## 1. 筋トレ記録

一番作り込みが必要な部分。特に「ドロップセット/ピラミッドセット/ジャイアントセット」への対応が設計のポイントになる。

```
exercises(種目マスタ)
- id
- name
- body_part (胸/背中/脚/肩/腕/体幹 など)
- is_custom (ユーザーが手入力で追加した独自種目かどうか)
- created_by (is_customがtrueの場合のみ、追加したuser_id)
- met_value (METs計算用の参考値、将来のカロリー自動算出で使用)

workout_sessions(1回のトレーニング)
- id
- user_id
- started_at
- ended_at

workout_set_groups(セットのまとまり)
- id
- session_id
- group_type (normal / drop_set / pyramid_set / giant_set)
- order_in_session

workout_sets(実際の1セット)
- id
- group_id
- exercise_id
- order_in_group
- weight_kg
- reps
- rest_seconds

my_training_lists(マイトレリスト)
- id
- user_id
- name

my_training_list_items(マイトレリストの中身)
- id
- list_id
- exercise_id
- target_sets
- target_reps
- order_index
```

**相談ポイント①：セット種別の表現方法**
「通常セット」も含めて全部 `workout_set_groups` というまとまり単位で管理する設計にした。理由は、ドロップセット(同じ種目で重量を落としながら連続実施)やジャイアントセット(複数種目を連続実施)を、後から「グループ化」という共通の仕組みで表現できるようにするため。これなら将来新しいセット形式が増えても、group_typeを増やすだけで対応できる。この方針でOKか一度確認したい。

## 2. 食事管理

「カロリーだけでなくPFC・ビタミン・ミネラルまで」という要件があるので、栄養素は正規化(別テーブルに分離)する設計にした。

```
nutrients(栄養素マスタ)
- id
- name (タンパク質、脂質、炭水化物、ビタミンC など)
- unit (g, mg, μg など)

foods(食品マスタ)
- id
- name
- source (公的食品DB由来 / ユーザー独自入力)

food_nutrients(食品ごとの栄養素量、100gあたり)
- food_id
- nutrient_id
- amount_per_100g

meal_logs(食事記録、1回の食事イベント)
- id
- user_id
- eaten_at (固定の朝昼晩枠ではなく、実際に食べた日時を自由入力)
- note

meal_log_items(食事記録の中身、食べたもの1品ごと)
- id
- meal_log_id
- food_id
- quantity_g
```

**なぜ栄養素を別テーブルに分離したか**: 「カロリー・タンパク質・脂質・炭水化物・ビタミン・ミネラル…」を全部 `foods` テーブルの列として持たせると、栄養素が増えるたびにテーブル構造を変更する必要が出てくる。栄養素をマスタ化して「食品×栄養素×量」の組み合わせで持たせる(正規化)ことで、柔軟に栄養素を追加・管理できる。これはDB設計の基本テクニックの一つ(実務でも頻出)。

**相談ポイント②：食品データの取得元**
`foods`/`food_nutrients` の初期データをどこから持ってくるかを決めたい。候補はこんな感じ。

- 文部科学省の「日本食品標準成分表」(無料・公的データ、あすけん等国内アプリも参考にしている定番ソース)
- 有料の栄養データベースAPI(海外の食品も強いが、コストが発生)

日本語ユーザー向けで、かつ「コストをかけずに始めたい」という今回の方針(広告なし・買い切りなし、というコスト意識)を考えると、まずは文部科学省のデータを使うのが妥当だと思うけど、この認識で合ってる？

## 3. 体重・活動管理

```
body_measurements(体組成記録)
- id
- user_id
- measured_at
- weight_kg
- body_fat_pct
- muscle_mass_kg

activity_logs(日々の活動量)
- id
- user_id
- date
- steps
- (スマホのヘルスケアAPIから取得する想定)

calorie_burn_estimates(METsベースの消費カロリー推定)
- id
- session_id (workout_sessionsと紐付け)
- user_id
- estimated_kcal
- computed_at

progress_photos(進捗写真)
- id
- user_id
- taken_at
- photo_url
- note
```

`calorie_burn_estimates` は `workout_sessions`(種目・セット内容)と `body_measurements`(体重)を組み合わせてMETs計算した結果を保存するテーブル。都度計算するのではなく結果を保存しておくのは、後で体重を修正・更新しても過去の消費カロリー記録が変わらないようにするため(履歴の正確性を保つ)。

## 4. 未確定・相談ポイントまとめ

1. **セット種別の表現方法**(グループ化方式)、この設計でOKか
2. **食品データの取得元**、文部科学省の食品成分DBを使う方針でOKか
