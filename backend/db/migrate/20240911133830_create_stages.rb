class CreateStages < ActiveRecord::Migration[7.2]
  def change
    create_table :stages do |t|
      t.uuid :uuid, null: false
      t.references :course, null: false, foreign_key: true, index: true
      t.string :prefix, null: false
      t.string :overview
      t.string :target
      t.integer :failed_case, default: 0, null: false
      t.integer :state, default: 0, null: false

      t.timestamps
    end

    add_index :stages, :uuid, unique: true
    add_index :stages, :state
  end
end
