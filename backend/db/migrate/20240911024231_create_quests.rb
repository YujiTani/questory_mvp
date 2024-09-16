class CreateQuests < ActiveRecord::Migration[7.2]
  def change
    create_table :quests do |t|
      t.uuid :uuid, null: false, index: {unique: true}
      t.string :name, null: true
      t.text :description, null: true
      t.integer :state, limit: 2, null: false, default: 0, index: true

      t.timestamps
    end
  end
end
