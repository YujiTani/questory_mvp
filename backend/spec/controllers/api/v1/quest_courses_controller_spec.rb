require 'rails_helper'

RSpec.describe Api::V1::QuestCoursesController, type: :controller do
  include LoginMacros

  describe "クエストに紐づくコース一覧を取得" do
    before { request.headers.merge!(basic_auth_headers) }

    let!(:quest) { create(:quest) }
    let!(:course1) { create(:course) }
    let!(:course2) { create(:course) }

    before do
      course1.associate_quest(quest)
      course2.associate_quest(quest)
    end

    context "正常系" do
      it "クエストに2つのコースが紐づいていること" do
        get :index, params: { quest_uuid: quest.uuid }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['courses']).to be_present
        expect(json['courses'].count).to eq(2)
      end
    end

    context "異常系" do
      it "クエストが存在しない場合はエラーが返されること" do
        get :index, params: { quest_uuid: 'invalid-uuid' }
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['error']).to be_present
      end
    end
  end

end
