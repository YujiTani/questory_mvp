require 'rails_helper'

RSpec.describe Api::V1::CourseStagesController, type: :controller do
  include LoginMacros

  describe "コースに紐づくステージ一覧を取得" do
    before { request.headers.merge!(basic_auth_headers) }

    let!(:course) { create(:course) }
    let!(:stage1) { create(:stage) }
    let!(:stage2) { create(:stage) }

    before do
      stage1.associate_course(course)
      stage2.associate_course(course)
    end

    context "正常系" do
      it "コースに紐づくステージ2つを取得できること" do
        get :index, params: { course_uuid: course.uuid }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['stages']).to be_present
        expect(json['stages'].count).to eq(2)
      end
    end

    context "異常系" do
      it "存在しないuuidの場合はエラーが返されること" do
        get :index, params: { course_uuid: 'invalid-uuid' }
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['error']).to be_present
      end
    end
  end

end
