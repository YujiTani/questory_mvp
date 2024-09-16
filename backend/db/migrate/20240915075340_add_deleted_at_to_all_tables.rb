class AddDeletedAtToAllTables < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :deleted_at, :datetime, default: nil
    add_column :rankings, :deleted_at, :datetime, default: nil
    add_column :user_high_scores, :deleted_at, :datetime, default: nil
    add_column :quests, :deleted_at, :datetime, default: nil
    add_column :courses, :deleted_at, :datetime, default: nil
    add_column :stages, :deleted_at, :datetime, default: nil
    add_column :questions, :deleted_at, :datetime, default: nil
    add_column :false_answers, :deleted_at, :datetime, default: nil
    add_column :words, :deleted_at, :datetime, default: nil
    add_column :feedback_issues, :deleted_at, :datetime, default: nil
  end
end
