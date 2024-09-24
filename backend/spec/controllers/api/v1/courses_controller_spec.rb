require 'rails_helper'

RSpec.describe Api::V1::CoursesController, type: :controller do
  include LoginMacros

  let(:valid_attributes) { { name: 'Test Course', description: 'This is a test course description' } }
  let(:invalid_attributes) { { name: 'a' * 61, description: 'a' * 1001 } }
  let(:update_attributes) { { name: 'Updated Course', description: 'Updated Description' } }

  describe 'コースを作成' do
    before { request.headers.merge!(basic_auth_headers) }

    context '正常系' do
      it '有効なパラメーターでコースを作成できること' do
        post :create, params: { course: valid_attributes }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['course']['name']).to eq(valid_attributes[:name])
        expect(json['course']['description']).to eq(valid_attributes[:description])
      end
    end

    context '異常系' do
      it '無効なパラメーターでクエストを作成できないこと' do
        post :create, params: { course: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['errors']).to be_present
      end
    end
  end

  describe 'コースを更新' do
    before { request.headers.merge!(basic_auth_headers) }

    context '正常系' do
      it '有効なパラメータでコースを更新できること' do
        course = create(:course)

        patch :update, params: { uuid: course.uuid, course: update_attributes }, as: :json
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['course']['name']).to eq(update_attributes[:name])
        expect(json['course']['description']).to eq(update_attributes[:description])
      end

      it 'クエストのdifficultyを更新できること' do
        course = create(:course)

        patch :update, params: { uuid: course.uuid, course: { difficulty: 1 } }, as: :json
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['course']['difficulty']).to eq(1)
      end
    end

    context '異常系' do
      it '無効なパラメータでクエストを更新できないこと' do
        course = create(:course)

        patch :update, params: { uuid: course.uuid, course: invalid_attributes }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['errors']).to be_present
      end

      it '範囲外のdifficultyを設定した場合、エラーが返されること' do
        course = create(:course)

        patch :update, params: { uuid: course.uuid, course: { difficulty: -1 } }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['errors']).to be_present
      end

      it '存在しないuuidを指定した場合、エラーが返されること' do
        patch :update, params: { uuid: 'non_existent_uuid', course: :update_attributes }, as: :json
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['message']).to be_present
      end
    end
  end

  describe 'コースを削除' do
    before { request.headers.merge!(basic_auth_headers) }

    context '正常系' do
      it '有効なuuidを指定した場合、コースを論理削除できること' do
        course = create(:course)

        delete :destroy, params: { uuid: course.uuid }, as: :json
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
      end

      it '論理削除から復元' do
        course = create(:course, deleted_at: Time.now)

        put :restore, params: { uuid: course.uuid }, as: :json
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        # deleted_atがnilになっていれば論理削除から復元されている
        expect(json['course']['deleted_at']).to be_nil
      end

      context '論理削除されたコースを完全削除' do
        it '有効なuuidを指定した場合、コースを完全削除できること' do
          course = create(:course, deleted_at: Time.now)

          delete :trashed, params: { uuid: course.uuid }, as: :json
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json['ok']).to be_truthy
        end
      end
    end

    context '異常系' do
      it '存在しないuuidを指定した場合、エラーが返されること' do
        create(:course)

        delete :destroy, params: { uuid: 'invalid_uuid' }, as: :json
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['message']).to be_present
      end

      it '存在しないuuidのコースを復元しようとした場合、エラーが返されること' do
        create(:course)

        put :restore, params: { uuid: 'invalid_uuid' }, as: :json
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['message']).to be_present
      end

      it '存在しないuuidのクエストを完全削除を実行しようとした場合、エラーが返されること' do
        create(:course)

        delete :trashed, params: { uuid: 'invalid_uuid' }, as: :json
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['message']).to be_present
      end
    end
  end
end
