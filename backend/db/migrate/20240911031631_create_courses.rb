class CreateCourses < ActiveRecord::Migration[7.2]
  def change
    create_table :courses do |t|
      t.uuid :uuid, null: false
      t.references :quest, null: false, foreign_key: true, index: true
      t.string :name
      t.text :description
      t.integer :difficulty, default: 0, null: false

      t.timestamps
    end

    add_index :courses, :uuid, unique: true
    add_index :courses, :difficulty
  end
end
