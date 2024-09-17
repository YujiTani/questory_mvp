require 'rails_helper'

RSpec.describe "Basic認証", type: :request do
  include LoginMacros

  let(:valid_user) { ENV["BASIC_AUTH_USER"] }
  let(:valid_password) { ENV["BASIC_AUTH_PASSWORD"] }
  let(:access_url) { "/api/v1" }

  context "認証情報が正しくリクエストが成功する" do
    it "リクエストが成功する" do
      get access_url, headers: basic_auth_headers(valid_user, valid_password)
      expect(response).to have_http_status(:ok)
    end
  end

  context "認証情報が不正でリクエストが拒否される" do
    it "リクエストが拒否される" do
      get access_url, headers: basic_auth_headers("wrong_user", "wrong_password")
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context "認証情報がない場合" do
    it "リクエストが拒否される" do
      get access_url
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
