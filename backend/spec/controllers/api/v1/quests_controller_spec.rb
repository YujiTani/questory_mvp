require 'rails_helper'

RSpec.describe Api::V1::QuestsController, type: :controller do
  include LoginMacros

  let(:valid_attributes) {
    { name: "Test Quest", description: "Test Description", state: :draft }
  }

  let(:invalid_attributes) {
    { name: "a" * 61, description: "a" * 1001, state: 'invalid_state' }
  }

  describe "GET /quests" do
    before { basic_auth }

    context "クエスト一覧を取得" do
      let!(:quests) { create_list(:quest, 5, valid_attributes) }

      it "正常なレスポンスを返し、クエスト数が5件であること" do
        get :index, params: {}
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json[:ok]).to be_truthy
        expect(json['quests'].count).to eq(5)
      end
    end

    context "クエスト一覧を取得" do
      it "レコードが存在しない" do
        get :index, params: {}
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['quests']).to be_empty
      end
    end
  end

end
