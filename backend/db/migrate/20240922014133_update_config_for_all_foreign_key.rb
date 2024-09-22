class UpdateConfigForAllForeignKey < ActiveRecord::Migration[7.2]
  # もしかしたら、DBの整合性が保てないかもしれないので、実行には注意する
  def change
    # coursesテーブル
    remove_foreign_key :courses, :quests
    # on_delete: :nullify 外部キーが削除された場合にnullを設定する
    add_foreign_key :courses, :quests, on_delete: :nullify

    # stagesテーブル
    remove_foreign_key :stages, :courses
    add_foreign_key :stages, :courses, on_delete: :nullify

    # questionsテーブル
    remove_foreign_key :questions, :stages
    add_foreign_key :questions, :stages, on_delete: :nullify

    # wordsテーブル
    remove_foreign_key :words, :questions
    add_foreign_key :words, :questions, on_delete: :nullify

    # false_answersテーブル
    remove_foreign_key :false_answers, :questions
    add_foreign_key :false_answers, :questions, on_delete: :nullify
  end
end
