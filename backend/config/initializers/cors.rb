# このファイルを変更した場合は、必ずサーバーを再起動してください。

# フロントエンドアプリケーションからAPIが呼び出された際のCORS問題を回避します。
# クロスオリジンのAjaxリクエストを受け入れるために、
# Cross-Origin Resource Sharing (CORS)を処理します。

# 詳細はこちらをご覧ください: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "*"

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
