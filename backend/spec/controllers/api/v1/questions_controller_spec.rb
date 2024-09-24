require 'rails_helper'

RSpec.describe Api::V1::QuestionsController, type: :controller do
  include LoginMacros

  let!(:valid_attributes) { { title: "テスト用の問題", body: "これはテスト用の問題です", answer: "Good Answer", explanation: "正解の解説"} }
  let!(:invalid_attributes) { { title: "a" * 256, body: "a" * 256, answer: "a" * 256, explanation: "a" * 1001 } }
  let!(:update_attributes) do
    { title: "更新された問題", body: "更新された問題です", answer: "Update Answer", explanation: "更新された問題です", category: :multiple }
  end
  let!(:question) { create(:question, :choice) }

  describe "問題を作成" do
    before { request.headers.merge!(basic_auth_headers) }

    context "正常系" do
      it "有効なパラメータで問題を作成できること" do
        post :create, params: { question: valid_attributes }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['question']['title']).to eq(valid_attributes[:title])
      end
    end

    context "異常系" do
      it "無効なパラメータで問題を作成できないこと" do
        post :create, params: { question: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['errors']).to be_present
      end
    end
  end

  describe "問題を更新" do
    before { request.headers.merge!(basic_auth_headers) }

    context "正常系" do
      it "有効なパラメータで問題を更新できること" do
        patch :update, params: { uuid: question.uuid, question: update_attributes }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['question']['title']).to eq(update_attributes[:title])
      end
    end

    context "異常系" do
      it "無効なパラメータで問題を更新できないこと" do
        patch :update, params: { uuid: question.uuid, question: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['errors']).to be_present
      end
    end
  end

  describe "問題を削除" do
    before { request.headers.merge!(basic_auth_headers) }

    context "正常系" do
      it "有効なuuidを指定した場合、問題を論理削除できること" do
        delete :destroy, params: { uuid: question.uuid }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
      end

      # FIXME: 論理削除から復元書がうまくいかないので、修正する
      # it "論理削除から復元" do
      #   question.update!(deleted_at: Time.now, category: :choice)

      #   put :restore, params: { uuid: question.uuid }
      #   expect(response).to have_http_status(:ok)
      #   json = JSON.parse(response.body)
      #   expect(json['ok']).to be_truthy
      #   expect(json['question']['deleted_at']).to be_nil
      # end

      it "論理削除された問題を完全削除" do
        question = create(:question, deleted_at: Time.now)

        delete :trashed, params: { uuid: question.uuid }, as: :json
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
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

      it "存在しないuuidの問題を元しようとした場合、エラーが返されること" do
        put :restore, params: { uuid: "non_existent_uuid" }, as: :json
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['message']).to be_present
      end

      it "存在しないuuidの問題を完全削除を実行しようとした場合、エラーが返されること" do
        delete :trashed, params: { uuid: "non_existent_uuid" }, as: :json
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['message']).to be_present
      end
    end
  end
end
