class CreateWords < ActiveRecord::Migration[7.2]
  def change
    create_table :words do |t|
      t.references :question, null: false, foreign_key: true, index: true
      t.string :name, null: false
      t.string :synonyms
      t.integer :index, null: false

      t.timestamps
    end

    add_index :words, :name
  end
end
