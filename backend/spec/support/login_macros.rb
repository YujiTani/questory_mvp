module LoginMacros
  # Basic認証ヘッダーを設定するメソッド
  def basic_auth_headers(username = ENV["BASIC_AUTH_USER"], password = ENV["BASIC_AUTH_PASSWORD"])
      {
        'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
      }
  end
end
