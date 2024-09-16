class CreateUserFeedbacks < ActiveRecord::Migration[7.2]
  def change
    create_table :user_feedbacks do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.references :course, foreign_key: true, index: true
      t.references :question, foreign_key: true, index: true
      t.text :details
      t.text :other

      t.timestamps
    end
  end
end
