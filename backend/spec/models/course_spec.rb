require 'rails_helper'

RSpec.describe Course, type: :model do
  describe 'バリデーションチェック' do
    let!(:quest) { create(:quest) }

    context '正常系' do
      it '有効な属性で作成できること' do
        course = build(:course)
        expect(course).to be_valid
      end

      it 'nameは空でも、登録できる' do
        course = build(:course, name: nil)
        expect(course).to be_valid
      end

      it 'nameが60文字以内であれば、登録できる' do
        course = build(:course, name: 'a' * 60)
        expect(course).to be_valid
      end

      it 'descriptionは空でも、登録できる' do
        course = build(:course, description: nil)
        expect(course).to be_valid
      end

      it 'descriptionが1000文字以内であれば、登録できる' do
        course = build(:course, description: 'a' * 1000)
        expect(course).to be_valid
      end
    end

    context '異常系' do
      it 'nameが61文字以上の場合は登録できない' do
        course = build(:course, name: 'a' * 61)
        expect(course).not_to be_valid
        expect(course.errors.full_messages).to be_present
      end

      it 'descriptionが1001文字以上の場合は登録できない' do
        course = build(:course, description: 'a' * 1001)
        expect(course).not_to be_valid
        expect(course.errors.full_messages).to be_present
      end

      it 'difficultyが0,1,2以外の場合は登録できない' do
        course = build(:course, difficulty: 3)
        expect(course).not_to be_valid
        expect(course.errors.full_messages).to be_present
      end
    end
  end

  describe 'メソッドの挙動チェック' do
    let!(:quest) { create(:quest) }
    let!(:course) { create(:course) }

    context '正常系' do
      it '論理削除が正しく行われること' do
        course.soft_delete
        expect(course.deleted_at).not_to be_nil
      end

      it '論理削除から復元されること' do
        course.soft_delete
        course.restore
        expect(course.deleted_at).to be_nil
      end

      it 'クエストとの紐づけが正しく行われること' do
        course.associate_quest(quest)
        expect(course).to be_valid
        expect(course.quest).to eq(quest)
      end

      it 'クエストとの紐づけが正しく解除されること' do
        course.unassociate_quest
        expect(course).to be_valid
        expect(course.quest).to be_nil
      end
    end

    context '異常系' do
      it '存在しないクエストとの紐づけを行うとエラーが発生すること' do
        expect { course.associate_quest('invalid_quest_id') }.to raise_error ActiveRecord::AssociationTypeMismatch
      end
    end
  end
end
