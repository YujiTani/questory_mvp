# ベースイメージ
FROM node:lts-alpine AS base
WORKDIR /app

# 依存関係のインストール
FROM base AS deps
COPY package*.json ./
RUN npm ci

# ビルダーステージ
FROM base AS builder
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# 実行ステージ
FROM base AS runner
ENV NODE_ENV production
WORKDIR /app

COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

# 実行コマンド
EXPOSE 3000
CMD ["node", "server.js"]
