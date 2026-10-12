# DB設計(叩き台)

`docs/requirements-fitness-app.md` の内容を元にした、テーブル構造の初期設計案。
`docs/tech-stack-and-conventions.md` で決めた通り、ローカル(Drift/SQLite)・クラウド(Supabase/PostgreSQL)ともに同じテーブル構造を基本とする想定。

- 作成日: 2026年8月
- ステータス: レビュー待ちの叩き台(未確定)
- 更新: 2026年10月、UI設計(`docs/design/`配下のhandoff README)に合わせて以下を反映
  - セット種別に `super_set` を追加(0.1)
  - 補助レップ(フォーストレップ)記録用に `workout_set_assists` を新設(1.)
  - 分割法エディタ用に `training_splits` / `split_days` を新設(1.)
  - 基本情報(設定)画面の計算用に `profiles` を拡張(0.)
  - 食事マイリスト(定番セット)用に `meal_lists` / `meal_list_items` を新設(2.)

## 0. 認証・ユーザー

Supabaseには標準で `auth.users`(メールアドレス・パスワード管理などを担う認証専用テーブル)が用意されているので、それをそのまま利用する。アプリ独自のユーザー情報は別テーブルに分離する。

- **なぜ分けるか**: 認証情報(パスワード等)とアプリ固有情報(身長・目標など)を同じテーブルに混ぜると、責務が曖昧になりセキュリティ的にも良くない。「認証は認証、プロフィールはプロフィール」と分離するのはDB設計の基本パターン。

```
profiles
- user_id (PK, auth.usersのidと1:1)
- display_name
- sex (male/female)                 -- 基礎代謝計算(Mifflin-St Jeor)に使用
- age                                -- 誕生日ではなく年齢を直接持つ(下記の通り)
- height_cm
- weight_kg                         -- 基礎代謝計算用の「現在体重」(下記の通りbody_measurementsとは別管理)
- target_weight_kg                  -- 「からだ」画面の目標体重表示に使用
- body_fat_pct (nullable)           -- Katch-McArdle式を使うかどうかの分岐に使用
- activity_level (low/light/mid/high/vhigh)  -- 活動係数 ×1.2〜×1.9
- goal (減量/体型維持/筋肥大/筋力アップ)
- experience_level (初心者/中級/上級) -- AIメニュー提案の種目数・強度決定に使用
- weekly_freq (1〜6)
- active_split_id (FK -> training_splits.id, nullable)
- maintenance_manual (bool)         -- メンテナンスカロリーを実測値で上書きするか
- maintenance_kcal_manual (nullable)
- created_at
```

- **体重・体脂肪率を`body_measurements`と別に`profiles`にも持たせる理由(方針変更)**: 当初は「二重管理を避けて`body_measurements`の最新値を使う」設計にしていたが、UI設計(`docs/design/Fitness App.dc.html`の`calc()`)の実装に合わせたところ、プロトタイプ自体が体重・体脂肪率を基本情報(プロフィール)側の単純な入力値として扱っていることが分かった。`body_measurements`はあくまで「からだ」タブでの時系列記録(履歴)、`profiles.weight_kg`/`body_fat_pct`は「基礎代謝計算に使う今の値」という役割分担にする(基本情報画面を開いた時点では、からだタブの最新記録をデフォルト値として表示し、そこから上書きできるようにする想定)。
- **年齢を`birth_date`ではなく`age`で持つ理由**: 同様にUI設計側が年齢を直接の数値入力として扱っていたため、誤差が出にくい誕生日管理より、プロトタイプの実装に合わせたシンプルな方を採用した。

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
- split_day_id (FK -> split_days.id, nullable) -- 分割法のどのDayとして行ったか
- started_at
- ended_at (nullable、中断中はNULL)
- status (completed / aborted) -- セット記録画面の「中断して保存」→ ended_atセット済みだがstatus=abortedで「途中終了」として履歴表示

workout_set_groups(セットのまとまり)
- id
- session_id
- group_type (normal / drop_set / pyramid_set / giant_set / super_set)
- order_in_session

workout_sets(実際の1セット)
- id
- group_id
- exercise_id
- order_in_group
- weight_kg
- reps
- rest_seconds

workout_set_assists(補助レップ = フォーストレップの記録)
- id
- set_id (FK -> workout_sets.id)
- scope (part / full)       -- 最後の数回だけ補助 / セット全体を補助
- assisted_reps              -- scope=partの時の補助回数。scope=fullなら対象repsと同数
- assisted_by (partner / trainer / self) -- パートナー/トレーナー/セルフ(片手補助)
- memo (nullable)

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
- set_type (normal / drop_set / pyramid_set / giant_set / super_set) -- マイトレ編集画面でセット方式を変更できるため

training_splits(分割法)
- id
- user_id
- preset (全身法 / 上下2分割 / PPL / 4分割 / 5分割 / カスタム)

split_days(分割法の各日)
- id
- split_id (FK -> training_splits.id)
- order_index (Day 1, Day 2...)
- label (nullable、空ならparts連結で表示名を生成)

split_day_parts(各日に割り当てる部位。複数選択のため中間テーブル)
- split_day_id (FK -> split_days.id)
- body_part (胸/背中/脚/肩/二頭/三頭/腹筋/臀部)
```

**相談ポイント①：セット種別の表現方法**
「通常セット」も含めて全部 `workout_set_groups` というまとまり単位で管理する設計にした。理由は、ドロップセット(同じ種目で重量を落としながら連続実施)やジャイアントセット(複数種目を連続実施)を、後から「グループ化」という共通の仕組みで表現できるようにするため。これなら将来新しいセット形式が増えても、group_typeを増やすだけで対応できる。この方針でOKか一度確認したい。

→ UI設計で `super_set`(次の種目と交互に休まず行う形式)が追加されたことで、この「グループ化方式にしておいて正解だった」ことが実証された形。enumを1つ増やすだけで対応できている。

**補足：補助レップを`workout_sets`に直接持たせず別テーブルにした理由**
補助ありのセットは全体の一部(多くは最後の数セットのみ)なので、全セットに毎回NULLの補助系カラムを持たせるより、「補助があったセットだけ`workout_set_assists`に1行追加する」方が無駄がない。UI側でも「セット番号をタップした時だけ詳細パネルが開く」という設計になっており、データ構造とUIの考え方が一致している。

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

meal_lists(食事マイリスト。「朝の定番」「トレ後」のような定番セット)
- id
- user_id
- name

meal_list_items(食事マイリストの中身)
- id
- list_id
- food_id
- quantity_g
- order_index
```

`my_training_lists`と同じ「よく使う組み合わせを登録しておき、ワンタップで一括記録する」という考え方を食事側にも適用したもの。食事記録画面で「この内容をマイリストに保存」した際に、`meal_log_items`の内容をコピーして`meal_lists`/`meal_list_items`を作る想定。

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

1. ~~**セット種別の表現方法**(グループ化方式)、この設計でOKか~~ → UI設計(`super_set`追加)でも破綻せず機能したため解決済みとする
2. **食品データの取得元**、文部科学省の食品成分DBを使う方針でOKか(UI設計では未言及のため引き続き未確定)
