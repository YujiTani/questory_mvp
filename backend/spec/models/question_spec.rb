require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'バリデーションチェック' do
    context '正常系' do
      it '有効な属性で作成できること' do
        question = build(:question)
        expect(question).to be_valid
      end

      it 'titleは255文字以内であれば、登録できること' do
        question = build(:question, title: 'a' * 255)
        expect(question).to be_valid
      end

      it 'bodyは255文字以内であれば、登録できること' do
        question = build(:question, body: 'a' * 255)
        expect(question).to be_valid
      end

      it 'answerは255文字以内であれば、登録できること' do
        question = build(:question, answer: 'a' * 255)
        expect(question).to be_valid
      end

      it 'explanationは空でも登録できること' do
        question = build(:question, explanation: nil)
        expect(question).to be_valid
      end

      it 'explanationは1000文字以内であれば、登録できること' do
        question = build(:question, explanation: 'a' * 1000)
        expect(question).to be_valid
      end

      it 'categoryはchoiceで登録できること' do
        question = build(:question, category: 'choice')
        expect(question).to be_valid
      end

      it 'categoryはmultipleで登録できること' do
        question = build(:question, category: 'multiple')
        expect(question).to be_valid
      end

      it 'categoryはassemblyで登録できること' do
        question = build(:question, category: 'assembly')
        expect(question).to be_valid
      end
    end

    context '異常系' do
      it 'titleは空では登録できないこと' do
        question = build(:question, title: nil)
        expect(question).to be_invalid
      end

      it 'bodyは空では登録できないこと' do
        question = build(:question, body: nil)
        expect(question).to be_invalid
      end

      it 'answerは空では登録できないこと' do
        question = build(:question, answer: nil)
        expect(question).to be_invalid
      end
    end
  end
end
