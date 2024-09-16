class CreateFalseAnswers < ActiveRecord::Migration[7.2]
  def change
    create_table :false_answers do |t|
      t.references :question, null: false, foreign_key: true, index: true
      t.string :answer, null: false

      t.timestamps
    end
  end
end
