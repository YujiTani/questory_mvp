class ChangeCategoryColumnForQuestion < ActiveRecord::Migration[7.2]
  def change
    reversible do |direction|
      change_table :questions do |t|
        direction.up do
          t.remove :category
          t.integer :category, default: 0, null: false
        end

        direction.down do
          t.remove :category
          t.string :category
        end

      end
    end
  end
end
