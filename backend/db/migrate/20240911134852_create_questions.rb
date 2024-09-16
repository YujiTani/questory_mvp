class CreateQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :questions do |t|
      t.uuid :uuid, null: false
      t.references :stage, null: false, foreign_key: true, index: true
      t.string :title, null: false
      t.string :answer, null: false
      t.string :category
      t.text :explanation

      t.timestamps
    end

    add_index :questions, :uuid, unique: true
    add_index :questions, :category
  end
end
