class CreateUserHighScores < ActiveRecord::Migration[7.2]
  def change
    create_table :user_high_scores do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.integer :total_high_score, default: 0, null: false
      t.integer :cumulative_clear_stage_count, default: 0, null: false
      t.integer :consecutive_correct_answers, default: 0, null: false
      t.integer :highest_rank, null: true

      t.timestamps
    end
  end
end
