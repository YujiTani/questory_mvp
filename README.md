# 開発環境構築
## ローカルマシンで動かす場合
### ローカル環境変数用意
.env.local.example ファイルをコピーし、 .env にリネームして必要な値を埋める

```
# 最上位ディレクトリに居る想定
cp .env.example .env

```

###  Dockerを用いてフロントエンドの環境を起動する
```
# フォアグラウンド
docker compose up --build

# バックグラウンド
docker compose up -d --build

```
