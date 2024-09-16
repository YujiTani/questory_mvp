class AddColumnToQuestion < ActiveRecord::Migration[7.2]
  def change
    add_column :questions, :body, :string, null: false
  end
end
