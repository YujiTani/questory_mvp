module LoginMacros
  # Basic認証ヘッダーを設定するメソッド
  def basic_auth_headers(username = ENV.fetch('BASIC_AUTH_USER', nil), password = ENV.fetch('BASIC_AUTH_PASSWORD', nil))
    {
      'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
    }
  end
end
