require 'rails_helper'

RSpec.describe Quest, type: :model do
  describe 'バリデーションテスト' do
    context '正常系' do
      it '有効な属性で作成できること' do
        quest = build(:quest)
        expect(quest).to be_valid
      end

      it 'nameは空でも、登録できる' do
        quest = build(:quest, name: nil)
        expect(quest).to be_valid
      end

      it 'nameが60文字以内であれば、登録できる' do
        quest = build(:quest, name: 'a' * 60)
        expect(quest).to be_valid
      end

      it 'descriptionは空でも、登録できる' do
        quest = build(:quest, description: nil)
        expect(quest).to be_valid
      end

      it 'descriptionが1000文字以内であれば、登録できる' do
        quest = build(:quest, description: 'a' * 1000)
        expect(quest).to be_valid
      end
    end

    context '異常系' do
      it 'nameが61文字以上の場合は登録できない' do
        quest = build(:quest, name: 'a' * 61)
        expect(quest).not_to be_valid
        expect(quest.errors.full_messages).to include("Name is too long (maximum is 60 characters)")
      end

      it 'descriptionが1001文字以上の場合は登録できない' do
        quest = build(:quest, description: 'a' * 1001)
        expect(quest).not_to be_valid
        expect(quest.errors.full_messages).to include("Description is too long (maximum is 1000 characters)")
      end

      it 'stateがdraft, published, archived以外の場合は登録できない' do
        expect { build(:quest, state: 'invalid_state') }.to raise_error(ArgumentError)
      end
    end

    context 'メソッドの挙動確認' do
      it '論理削除されていること' do
        quest = create(:quest)
        quest.soft_delete
        expect(quest.deleted_at).not_to be_nil
      end

      it '論理削除から復元されていること' do
        quest = create(:quest)
        quest.soft_delete
        quest.restore
        expect(quest.deleted_at).to be_nil
      end
    end
  end
end
