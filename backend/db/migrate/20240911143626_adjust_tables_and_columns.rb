class AdjustTablesAndColumns < ActiveRecord::Migration[7.2]
  def change
    # stages テーブルの修正
    add_column :stages, :complete_case, :integer, default: 0, null: false

    # user_high_scores テーブルの修正
    rename_column :user_high_scores, :total_high_score, :total_high_scores

    # words テーブルの修正
    rename_column :words, :index, :order_index
  end
end
