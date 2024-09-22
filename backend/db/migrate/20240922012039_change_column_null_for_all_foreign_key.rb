class ChangeColumnNullForAllForeignKey < ActiveRecord::Migration[7.2]
  def change
    change_column_null :courses, :quest_id, true, nil
    change_column_null :stages, :course_id, true, nil
    change_column_null :questions, :stage_id, true, nil
    change_column_null :words, :question_id, true, nil
    change_column_null :false_answers, :question_id, true, nil
  end
end
