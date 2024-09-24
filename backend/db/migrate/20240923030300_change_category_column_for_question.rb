class ChangeCategoryColumnForQuestion < ActiveRecord::Migration[7.2]
  def change
    reversible do |direction|
      change_table :questions do |t|
        direction.up   { t.change :category, :string }
        direction.down { t.change :category, :integer }
      end
    end
  end
end
