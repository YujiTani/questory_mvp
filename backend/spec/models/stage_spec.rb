require 'rails_helper'

RSpec.describe Stage, type: :model do
  describe 'バリデーションチェック' do
    context '正常系' do
      it '有効な属性で作成できること' do
        stage = build(:stage)
        expect(stage).to be_valid
      end

      it 'prefixは5文字以内であれば、登録できる' do
        stage = build(:stage, prefix: 'a' * 5)
        expect(stage).to be_valid
      end

      it 'overviewは空でも、登録できる' do
        stage = build(:stage, overview: nil)
        expect(stage).to be_valid
      end

      it 'overviewは255文字以内であれば、登録できる' do
        stage = build(:stage, overview: 'a' * 255)
        expect(stage).to be_valid
      end

      it 'targetは空でも、登録できる' do
        stage = build(:stage, target: nil)
        expect(stage).to be_valid
      end

      it 'targetは255文字以内であれば、登録できる' do
        stage = build(:stage, target: 'a' * 255)
        expect(stage).to be_valid
      end
    end

    context '異常系' do
      it 'prefixが空の場合は登録できない' do
        stage = build(:stage, prefix: nil)
        expect(stage).not_to be_valid
        expect(stage.errors.full_messages).to be_present
      end

      it 'prefixが重複している場合は登録できない' do
        create(:stage, prefix: 'ST1')
        duplicate_stage = build(:stage, prefix: 'ST1')
        expect(duplicate_stage).not_to be_valid
        expect(duplicate_stage.errors.full_messages).to be_present
      end

      it 'prefixが6文字以上の場合は登録できない' do
        stage = build(:stage, prefix: 'a' * 6)
        expect(stage).not_to be_valid
        expect(stage.errors.full_messages).to be_present
      end

      it 'overviewが256文字以上の場合は登録できない' do
        stage = build(:stage, overview: 'a' * 256)
        expect(stage).not_to be_valid
        expect(stage.errors.full_messages).to be_present
      end

      it 'targetが256文字以上の場合は登録できない' do
        stage = build(:stage, target: 'a' * 256)
        expect(stage).not_to be_valid
        expect(stage.errors.full_messages).to be_present
      end

      it 'failed_caseが3以上の場合は登録できない' do
        stage = build(:stage, failed_case: 3)
        expect(stage).not_to be_valid
        expect(stage.errors.full_messages).to be_present
      end

      it 'complete_caseが3以上の場合は登録できない' do
        stage = build(:stage, complete_case: 3)
        expect(stage).not_to be_valid
        expect(stage.errors.full_messages).to be_present
      end
    end
  end
end
