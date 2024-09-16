class CreateRankings < ActiveRecord::Migration[7.2]
  def change
    create_table :rankings do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.integer :rank, null: false
      t.integer :score, null: false

      t.timestamps
    end

    # unique制約
    add_index :rankings, [:user_id, :rank], unique: true
  end
end
