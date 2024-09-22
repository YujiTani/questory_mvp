require 'rails_helper'

RSpec.describe Api::V1::StagesController, type: :controller do
  include LoginMacros

  let!(:valid_attributes) { { prefix: "ST1", overview: "これはテストです", target: "初心者用" } }
  let!(:invalid_attributes) { { prefix: "a" * 6, overview: "a" * 256, target: "a" * 256} }
  let!(:update_attributes) { { prefix: "ST2", overview: "サンプルです", target: "初級者用" } }
  let!(:stage) { create(:stage) }

  describe "ステージを作成" do
    before { request.headers.merge!(basic_auth_headers) }

    context "正常系" do
      it "有効なパラメーターでステージを作成できること" do
        post :create, params: { stage: valid_attributes }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['stage']['prefix']).to eq(valid_attributes[:prefix])
      end
    end

    context "異常系" do
      it "無効なパラメーターでステージを作成できないこと" do
        post :create, params: { stage: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['errors']).to be_present
      end
    end
  end

  describe "ステージを更新" do
    before { request.headers.merge!(basic_auth_headers) }

    context "正常系" do

      it "有効なパラメータでステージを更新できること" do
        patch :update, params: { uuid: stage.uuid, stage: update_attributes }, as: :json
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['stage']['prefix']).to eq(update_attributes[:prefix])
      end

      it "ステージのprefixを更新できること" do
        patch :update, params: { uuid: stage.uuid, stage: { prefix: "ST2" } }, as: :json
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['stage']['prefix']).to eq("ST2")
      end

      it "ステージのoverviewを更新できること" do
        patch :update, params: { uuid: stage.uuid, stage: { overview: "サンプルです" } }, as: :json
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['stage']['overview']).to eq("サンプルです")
      end

      it "ステージのtargetを更新できること" do
        patch :update, params: { uuid: stage.uuid, stage: { target: "初級者用" } }, as: :json
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['stage']['target']).to eq("初級者用")
      end

      it "ステージのstateを更新できること" do
        patch :update, params: { uuid: stage.uuid, stage: { state: 1 } }, as: :json
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['stage']['state']).to eq('published')
      end

      it "ステージのfailed_caseを更新できること" do
        patch :update, params: { uuid: stage.uuid, stage: { failed_case: 1 } }, as: :json
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['stage']['failed_case']).to eq(1)
      end

      it "ステージのcomplete_caseを更新できること" do
        patch :update, params: { uuid: stage.uuid, stage: { complete_case: 1 } }, as: :json
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['stage']['complete_case']).to eq(1)
      end
    end

    context "異常系" do
      it "無効なパラメーターでステージを更新できないこと" do
        patch :update, params: { uuid: stage.uuid, stage: invalid_attributes }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['errors']).to be_present
      end

      it "存在しないuuidを指定した場合、エラーが返されること" do
        patch :update, params: { uuid: "non_existent_uuid", stage: :update_attributes }, as: :json
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['message']).to be_present
      end
    end
  end

  describe "ステージを削除" do
    before { request.headers.merge!(basic_auth_headers) }

    context "正常系" do
      it "有効なuuidを指定した場合、ステージを論理削除できること" do
        delete :destroy, params: { uuid: stage.uuid }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
      end

      it "論理削除から復元" do
        stage = create(:stage, deleted_at: Time.now)

        put :restore, params: { uuid: stage.uuid }, as: :json
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['stage']['deleted_at']).to be_nil
      end

      context "論理削除されたステージを完全削除" do
        it "有効なuuidを指定した場合、ステージを完全削除できること" do
          stage = create(:stage, deleted_at: Time.now)

          delete :trashed, params: { uuid: stage.uuid }, as: :json
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json['ok']).to be_truthy
        end
      end
    end

    context "異常系" do
      it "存在しないuuidを指定した場合、エラーが返されること" do
        delete :destroy, params: { uuid: "non_existent_uuid" }
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['message']).to be_present
      end

      it "存在しないuuidのステージを復元しようとした場合、エラーが返されること" do
        delete :destroy, params: { uuid: "non_existent_uuid" }
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['message']).to be_present
      end

      it "存在しないuuidのステージを完全削除を実行しようとした場合、エラーが返されること" do
        delete :trashed, params: { uuid: "non_existent_uuid" }, as: :json
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['message']).to be_present
      end
    end
  end
end
