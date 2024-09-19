require 'rails_helper'

RSpec.describe Api::V1::QuestsController, type: :controller do
  include LoginMacros

  let(:valid_attributes) do
    { name: "Test Quest", description: "Test Description", state: :draft }
  end

  let(:invalid_attributes) do
    { name: "a" * 61, description: "a" * 1001, state: 'invalid_state' }
  end

  describe "クエスト一覧を取得" do
    before { request.headers.merge!(basic_auth_headers) }

    context "正常系" do

      it "limit6の場合、6件取得できること" do
        create_list(:quest, 50, valid_attributes)

        get :index, params: { limit: 6 }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['quests'].count).to eq(6)
        expect(json['total']).to eq(50)
      end

      it "100件のクエストが存在する場合、50件取得できること" do
        create_list(:quest, 100, valid_attributes)

        get :index
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['quests'].count).to eq(50)
        expect(json['total']).to eq(100)
      end

      it "論理削除されたレコードしかない場合、空のリストが返されること" do
        # 論理削除されたレコードを50件追加
        create_list(:quest, 50, valid_attributes.merge(deleted_at: Time.now))

        get :index
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['quests']).to be_empty
        expect(json['total']).to eq(0)
      end

    end

    context "異常系" do
      it "limit,offsetが不正な値の場合、エラーが返されること" do
        create_list(:quest, 50, valid_attributes)

        get :index, params: { limit: -1, offset: -1 }
        expect(response).to have_http_status(:internal_server_error)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
      end

    end

  end

end
