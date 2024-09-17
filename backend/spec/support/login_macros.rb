module LoginMacros
  # Basic認証
  def basic_auth(username = ENV["BASIC_AUTH_USER"], password = ENV["BASIC_AUTH_PASSWORD"])
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(
      username,
      password
    )
  end
end
