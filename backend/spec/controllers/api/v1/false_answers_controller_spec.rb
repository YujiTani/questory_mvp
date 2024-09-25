require 'rails_helper'

RSpec.describe Api::V1::FalseAnswersController, type: :controller do
  include LoginMacros

  let!(:valid_attributes) { { answer: 'false answer' } }

  describe '誤回答を作成' do
    before { request.headers.merge!(basic_auth_headers) }

    context '正常系' do
      it '有効なパラメータで誤回答を作成できること' do
        post :create, params: { false_answer: valid_attributes }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['false_answer']['answer']).to eq(valid_attributes[:answer])
      end
    end
  end
end
