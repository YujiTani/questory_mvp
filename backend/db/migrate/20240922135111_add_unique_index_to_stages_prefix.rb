class AddUniqueIndexToStagesPrefix < ActiveRecord::Migration[7.2]
  def change
    add_index :stages, :prefix, unique: true
  end
end
