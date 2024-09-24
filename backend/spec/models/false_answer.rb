require 'rails_helper'

RSpec.describe FalseAnswer, type: :model do
  describe 'バリデーションチェック' do
    let!(:false_answer) { create(:false_answer) }

    context '正常系' do
      it '有効な属性で作成できること' do
        false_answer = build(:false_answer)
        expect(false_answer).to be_valid
      end
    end

    context '異常系' do
      it 'answerが空では、作成できないこと' do
        false_answer = build(:false_answer, answer: nil)
        expect(false_answer).not_to be_valid
      end

      it 'answerが255文字を超えると、作成できないこと' do
        false_answer = build(:false_answer, answer: 'a' * 256)
        expect(false_answer).not_to be_valid
      end
    end
  end

  describe 'メソッドの挙動チェック' do
    let!(:question) { create(:question) }
    let!(:false_answer) { create(:false_answer) }

    context '正常系' do
      it '論理削除が正しく行われること' do
        false_answer.soft_delete
        expect(false_answer.deleted_at).not_to be_nil
      end

      it '論理削除から復元されること' do
        false_answer.soft_delete
        false_answer.restore
        expect(false_answer.deleted_at).to be_nil
      end

      it '問題に紐づけが正しく行われること' do
        false_answer.associate_question(question)
        expect(false_answer).to be_valid
        expect(false_answer.question).to eq(question)
      end

      it '問題の紐づけが解除されること' do
        false_answer.associate_question(question)
        false_answer.unassociate_question
        expect(false_answer).to be_valid
        expect(false_answer.question).to be_nil
      end
    end

    context '異常系' do
      it '存在しない問題に紐づけを行うとエラーが発生すること' do
        expect { false_answer.associate_question('invalid_question_id') }.to raise_error ActiveRecord::AssociationTypeMismatch
      end
    end
  end
end
