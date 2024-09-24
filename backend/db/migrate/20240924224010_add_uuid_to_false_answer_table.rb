class AddUuidToFalseAnswerTable < ActiveRecord::Migration[7.2]
  def change
    add_column :false_answers, :uuid, :uuid, null: false
    add_index :false_answers, :uuid, unique: true
  end
end
