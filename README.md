# サービス概要

15 分程度の短い隙間時間でも、スマホさえあればプログラミング学習できるアプリ

# このサービスへの思い・作りたい理由

アプリの試作型は既につくってしまったので、想いなどをまとめた記事が note にあります。(思いや動機に関しては、記事内の３つの動機という項目に書いてあります。)
(https://note.com/calm_borage173/n/n471630b64d15)

詳細は記事に書いてあるので、ここでは箇条書きにさせていただくと以下となります

- 過去に 365 日英語学習を継続できた「Duolingo」というアプリの仕組みをプログラミング学習にも応用できないかと考えた
- RUNTEQ に入り、たくさんの未経験者に教えているうちに、人に教えることが楽しく、好きだと気づいた
  しかしカリキュラムが進むにつれ教える時間を確保できなくなったので、自分の代わりに学習のサポートできるアプリを開発しようと思った
- RUNTEQ 生の中には、なかなか PC 前で学習する環境を整えられずに困っている人たちがいるので、スマホが使えれば学習できる環境を用意したいと考えた

# ユーザー層について

決めたユーザー層についてどうしてその層を対象にしたのかそれぞれ理由を教えてください。

- ユーザー層は、プログラミング学習の初学者(特に RUNTEQ に入学してきた方たち)

# サービスの利用イメージ

日常生活のちょっとした隙間時間に、アプリを開いてぽちぽち学習する

例）

1. 電車に乗っている時間
2. 仕事が遅くなった日、カリキュラムを進めたいが、時間も遅いため、はやく寝ないといけない
3. 育児や、家事が片付き少しだけ時間ができたが、PC を開いて勉強するほどの時間はない

## ユーザーがこのサービスをどのように利用できて、それによってどんな価値を得られるかの説明

隙間時間を有効にプログラミング学習にあてることで、フルコミットでない RUNTEQ 受講生に発生しがちな学習間隔が空いてしまう問題の解消をめざす
これにより、プログラミング学習の天敵である学習内容を忘れてしまう事を軽減させ、途中離脱率をさげられる

## ユーザーの獲得について

RUNTEQ に入学してきた生徒たちに対して案内を設け、隙間時間での学習は、私が作ったアプリを使って勉強するように促していく
Qitta や Zenn で記事を書き、X を使って宣伝していく

# サービスの差別化ポイント・推しポイント

## 競合となるサービス

Progate、ドットインストール、Codecademy あたりが競合になるのではないかと思っている

- progate … 手軽にプログラミング学習ができるという点で、競合となりうるがスマホでの学習は非推奨のため、問題ないとかんがえる
- ドットインストール … スマホでも問題なく使用できるが、動画視聴という形になるため、ハンズオンできない場合、学習効率が低くなるとかんがえる、また継続的な学習意欲を掻き立てる仕組みに乏しいので、こちらがこの部分を強くすれば差別化は可能だと思っている

- Codecademy … 英語サイト、code をタイピングする必要があるので、スマホでの学習に向いていない

# 機能候補

## 使用予定の技術スタック

|                |                                                             |
| -------------- | ----------------------------------------------------------- |
| フロントエンド | TypeScript / React / Next.js / TailwindCSS / shadch/ui / v0 |
| バックエンド   | Ruby / Ruby on Rails / PostgreSQL                           |
| インフラ       | Cloudflare / さくら VPS / Nginx / Docker                    |
| CI/CD          | Cloudflare / GitHub Actions                                 |
| 認証           | OAuth 2.0 / LINE / Github                                   |
| 開発環境       | Mac Apple Silicon / Cursor / Github Copilot                 |

## 現状作ろうと思っている機能

### バックエンド

- 認証機能(SNS 認証, LINE を優先)
- ユーザーデータの管理(CRAD、累計スコア、クリア問題数、ユーザーのレベル、連続ログイン日数)
- 問題の管理機能(CRAD)
- ユーザーからのフィードバックデータ管理

### フロントエンド

- 問題を解く機能(下記は、問題の種類)
- SQL
- DB を確認できる機能
- SQL の用語学習
- SQL の基礎的な使い方
- SQL の組み立て練習
- 複数のテーブルを使う問題
- 現場を想定したデータ取得問題(営業成績の可視化など)

- ORM(ActiveRecord)
- ActiveRecord の用語学習
- ActiveRecord の基礎的な使い方
- リレーション系の問題
- ActiveRecord の組み立て練習
- 指定された SQL を ActiveRecord で作る問題
- 解凍後に作成した ActiveRecord を SQL に変換してみせる機能

- 累計クリア問題数を表示する機能
- 連続正答数を表示する機能
- クリアスコアを表示する機能(独自の計算式を用意する)
- SNS にクリア画面をシェアする機能
- アプリ内の問題をフィードバックしてもらえる機能
- 一定時間、問題の解答状況を保存する機能(1 ステージ、10 個の問題という単位にするので、朝少しプレイ、夜仕事おわってプレイする状況を考慮して)
- 連続ログイン日数を表示する機能
- 累計クリアスコアで、レベルが上がる機能
- ユーザー同士のスコアランキング表示機能
- 1 日のアプリプレイ回数を制限する機能
- LINE に通知する機能(連続ログイン日数など)

高度な機能

- LINE に通知する機能(連続ログイン日数など)
- 問題の自動生成機能(精度が安定するならば、LLM アプリを開発して問題はここから出力した)

## MVP リリース時に作っていたいもの

### インフラ

- VPS を使用する
- Docker を使用した環境構築
- nginx(リバースプロキシ) を使用する
- SSL 化する
- 独自ドメインを使用
- Github Actions を使用した CI/CD 環境の構築

### バックエンド

- API ドキュメント作成
- 問題の管理機能(CRAD)

### フロントエンド

- 問題を解く機能(下記は、問題の種類)
- SQL
- SQL の用語学習
- SQL の基礎的な使い方

## 本リリースで追加する機能

### インフラ

- CI/CD 自動デプロイ

### バックエンド

- 認証機能(SNS 認証, LINE を優先)
- ユーザーデータの管理(スコア、クリア問題数)
- ユーザーからのフィードバックデータ管理

### フロントエンド

- 認証機能(SNS 認証, LINE を優先)
- バックエンドとの連携

- DB を確認できる機能
- 複数のテーブルを使う問題
- 現場を想定したデータ取得問題(営業成績の可視化など)

- ORM(ActiveRecord)
- ActiveRecord の用語学習
- ActiveRecord の基礎的な使い方
- リレーション系の問題
- ActiveRecord の組み立て練習
- 指定された SQL を ActiveRecord で作る問題
- 解凍後に作成した ActiveRecord を SQL に変換してみせる機能

- 累計クリア問題数を表示する機能
- 連続正答数を表示する機能
- クリアスコアを表示する機能(独自の計算式を用意する)
- SNS にクリア画面をシェアする機能
- アプリ内の問題をフィードバックしてもらえる機能
- 一定時間、問題の解答状況を保存する機能(1 ステージ、10 個の問題という単位にするので、朝少しプレイ、夜仕事おわってプレイする状況を考慮して)
- 連続ログイン日数を表示する機能
- 累計クリアスコアで、レベルが上がる機能
- ユーザー同士のスコアランキング表示機能

# ■ 機能の実装方針予定

## 問題を解く機能

- 解答データとユーザーの解答を比較して、正誤判定を行う
- ユーザーが解答する種類を増やすことで、様々なバリエーションが用意できるはず(スマホでの操作しやすさを考慮する)
- ベストは LLM アプリを開発し、問題を自動生成できるようにすること

## 問題に使用されるテーブルを確認できる機能

- shemas ファイルを読み込み、テーブル UI を作成し表示させるまたは、DB の内容を JSON 形式で表示させる

## SNS シェア機能

- 下記のようなライブラリを使って実装するつもり
  (https://github.com/nygardk/react-share?tab=readme-ov-file)

---

構築方法や操作方法

# 開発環境構築

## ローカルマシンで動かす場合

### Docker を用いてコンテナを起動(backend、frontend、db、nginx すべてのコンテナが起動する)

```
# フォアグラウンド
docker compose up --build

# バックグラウンド
docker compose up -d --build

```

---

## 本番環境へのデプロイ

### 1. 本番環境変数用意

.env.example ファイルをコピーし、.env にリネームして必要な値を埋める
これらは backend であれば、config/database.rb などのファイルを自分で更新する

```
# 最上位ディレクトリに居る想定
cp .env.example .env

```

### 2. イメージをビルド

```
# 最上位ディレクトリに居る想定
docker build -t {username/reponame:tagname} /frontend or /backend

# apple siliconチップの場合(deploy先次第では、プラットフォーム指定が必要)
docker build --platform linux/amd64 -t {username/reponame:tagname} /frontend or /backend

# comose.ymlに platform 設定を追加している場合
docker compose -f compose-prod.yml build frontend or backend
```

### 3. イメージを DockerHub に push

```
# さっき作ったイメージを使う
docker push {username/reponame:tagname}

# comose.ymlに platform 設定を追加している場合
docker compose -f compose-prod.yml push frontend or backend
```

### 4. ssh 接続(リモート接続)

```
ssh {ログイン名}@{接続先}
```

### 5. リモート接続先に clone

```
# gitなど本番の開発環境構築は完了している前提

git pull git@github.com:YujiTani/questory_mvp.git
```

### 6. DockerHub から push したイメージを pull

作業前に、本番環境の環境変数を更新する

```
docker compose -f compose-prod.yml pull frontend or backend
```

### 7. イメージからコンテナ起動

```
docker compose -f compose-prod.yml up -d frontend or backend
```

---

## ライブラリの追加

clean な一時コンテナを使用した追加方法を記述

```
# Ruby on Rails Gemの追加
docker compose run --rm backend gem install  {追加したいgem名}

# JavaScriptライブラリの追加
docker compose run --rm frontend yarn add {追加したいライブラリ名}
```

---

## 自己証明書の作成

開発環境では、自己証明書を使用する
コマンド実行後、情報入力を求められるが、すべてデフォルト値で問題ない

```
# 最上位ディレクトリに居る想定

openssl req -x509 -newkey rsa:2048 -days 365 -nodes -keyout nginx/ssl/server.key -out nginx/ssl/server.crt
```

## rubocop の設定

コードチェックを行う

```
# 最上位ディレクトリに居る想定

docker compose run --rm backend bundle exec rubocop --auto-correct
```

コードの自動修正

```
docker compose run --rm backend bundle exec rubocop -a
```
