require 'rails_helper'

RSpec.describe Api::V1::QuestsController, type: :controller do
  include LoginMacros

  let(:valid_attributes) { { name: 'Test Quest', description: 'This is a test quest description' } }
  let(:invalid_attributes) { { name: 'a' * 61, description: 'a' * 1001 } }
  let(:update_attributes) { { name: 'Updated Quest', description: 'Updated Description' } }

  describe 'クエスト一覧を取得' do
    before { request.headers.merge!(basic_auth_headers) }

    context '正常系' do
      it 'limit6の場合、6件取得できること' do
        create_list(:quest, 50, valid_attributes)

        get :index, params: { limit: 6 }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['quests'].count).to eq(6)
        expect(json['total']).to eq(50)
      end

      it '100件のクエストが存在する場合、50件取得できること' do
        create_list(:quest, 100, valid_attributes)

        get :index
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['quests'].count).to eq(50)
        expect(json['total']).to eq(100)
      end

      it '論理削除されたレコードしかない場合、空のリストが返されること' do
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

    context '異常系' do
      it 'limit,offsetが不正な値の場合、エラーが返されること' do
        create_list(:quest, 50, valid_attributes)

        get :index, params: { limit: -1, offset: -1 }
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['errors']).to be_present
      end
    end
  end

  describe 'クエストを作成' do
    before { request.headers.merge!(basic_auth_headers) }

    context '正常系' do
      it '有効なパラメーターでクエストを作成できること' do
        expect { post :create, params: { quest: valid_attributes }, as: :json }.to change(Quest, :count).by(1)
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['quest']['name']).to eq('Test Quest')
      end
    end

    context '異常系' do
      it '無効なパラメーターでクエストを作成できないこと' do
        post :create, params: { quest: invalid_attributes }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['errors']).to be_present
      end
    end
  end

  describe 'クエストを更新' do
    before { request.headers.merge!(basic_auth_headers) }

    context '正常系' do
      it '有効なパラメータでクエストを更新できること' do
        quest = create(:quest)

        patch :update, params: { uuid: quest.uuid, quest: update_attributes }, as: :json
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['quest']['name']).to eq('Updated Quest')
        expect(json['quest']['description']).to eq('Updated Description')
      end

      it 'クエストのstateを更新できること' do
        quest = create(:quest)

        patch :update, params: { uuid: quest.uuid, quest: { state: 'published' } }, as: :json
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        expect(json['quest']['state']).to eq('published')
      end
    end

    context '異常系' do
      it '無効なパラメータでクエストを更新できないこと' do
        quest = create(:quest)

        patch :update, params: { uuid: quest.uuid, quest: invalid_attributes }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['errors']).to be_present
      end

      it '存在しないstateを指定した場合、エラーが返されること' do
        quest = create(:quest)

        patch :update, params: { uuid: quest.uuid, quest: { state: -1 } }, as: :json
        expect(response).to have_http_status(:internal_server_error)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        # TODO: enumで定義されていない値を指定した場合、エラーメッセージが入らないので修正する
      end

      it '存在しないuuidを指定した場合、エラーが返されること' do
        patch :update, params: { uuid: 'non_existent_uuid', quest: { name: 'Updated Quest' } }, as: :json
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['message']).to be_present
      end
    end
  end

  describe 'クエストを削除' do
    before { request.headers.merge!(basic_auth_headers) }

    context '正常系' do
      it '有効なuuidを指定した場合、クエストを論理削除できること' do
        quest = create(:quest)

        delete :destroy, params: { uuid: quest.uuid }, as: :json
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
      end

      it '論理削除から復元' do
        quest = create(:quest, deleted_at: Time.now)

        put :restore, params: { uuid: quest.uuid }, as: :json
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
        # deleted_atがnilになっていれば論理削除から復元されている
        expect(json['quest']['deleted_at']).to be_nil
      end

      context '論理削除されたクエストを完全削除' do
        it '有効なuuidを指定した場合、クエストを完全削除できること' do
          quest = create(:quest, deleted_at: Time.now)

          delete :trashed, params: { uuid: quest.uuid }, as: :json
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json['ok']).to be_truthy
        end
      end
    end

    context '異常系' do
      it '存在しないuuidを指定した場合、エラーが返されること' do
        create(:quest)

        delete :destroy, params: { uuid: 'invalid_uuid' }, as: :json
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['message']).to be_present
      end

      it '存在しないuuidのクエストを復元しようとした場合、エラーが返されること' do
        create(:quest)

        put :restore, params: { uuid: 'invalid_uuid' }, as: :json
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['message']).to be_present
      end

      it '存在しないuuidのクエストを完全削除を実行しようとした場合、エラーが返されること' do
        create(:quest)

        delete :trashed, params: { uuid: 'invalid_uuid' }, as: :json
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['message']).to be_present
      end
    end
  end

  describe '指定クエストにコースを紐付ける' do
    before { request.headers.merge!(basic_auth_headers) }

    let!(:quest) { create(:quest) }
    let!(:course1) { create(:course) }
    let!(:course2) { create(:course) }

    context '正常系' do
      it '指定のクエストにコースが紐づくこと' do
        patch :associate_courses, params: { uuid: quest.uuid, course_uuids: [course1.uuid] }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
      end

      it '指定のクエストに2つのコースが紐づくこと' do
        patch :associate_courses, params: { uuid: quest.uuid, course_uuids: [course1.uuid, course2.uuid] }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_truthy
      end
    end

    context '異常系' do
      it 'クエストが存在しない場合はエラーが返されること' do
        patch :associate_courses, params: { uuid: 'invalid-uuid', course_uuids: [course1.uuid, course2.uuid] }
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['ok']).to be_falsey
        expect(json['message']).to be_present
      end
    end
  end
end
