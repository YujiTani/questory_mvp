# 開発環境構築
## ローカルマシンで動かす場合
###  Dockerを用いてコンテナを起動(backend、frontend、db、nginxすべてのコンテナが起動する)
```
# フォアグラウンド
docker compose up --build

# バックグラウンド
docker compose up -d --build

```

## 本番環境へのデプロイ

### 1. 本番環境変数用意
.env.example ファイルをコピーし、.env にリネームして必要な値を埋める
これらはbackendであれば、config/database.rbなどのファイルを自分で更新する

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

### 3. イメージをDockerHubにpush

```
# さっき作ったイメージを使う
docker push {username/reponame:tagname}

# comose.ymlに platform 設定を追加している場合
docker compose -f compose-prod.yml push frontend or backend
```

### 4. ssh接続(リモート接続)
```
ssh {ログイン名}@{接続先}
```

### 5. リモート接続先にclone
```
# gitなど本番の開発環境構築は完了している前提

git pull git@github.com:YujiTani/questory_mvp.git
```

### 6. DockerHubから push したイメージを pull
```
docker compose -f compose-prod.yml pull frontend or backend
```

### 7. イメージからコンテナ起動
```
docker compose -f compose-prod.yml up -d frontend or backend
```
