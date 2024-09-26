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
