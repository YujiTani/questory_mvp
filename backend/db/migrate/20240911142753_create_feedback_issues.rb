class CreateFeedbackIssues < ActiveRecord::Migration[7.2]
  def change
    create_table :feedback_issues do |t|
      t.references :user_feedback, null: false, foreign_key: true, index: true
      t.string :issue, null: false

      t.timestamps
    end

    add_index :feedback_issues, :issue
  end
end

