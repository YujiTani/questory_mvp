# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_09_24_224010) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.uuid "uuid", null: false
    t.bigint "quest_id"
    t.string "name"
    t.text "description"
    t.integer "difficulty", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["difficulty"], name: "index_courses_on_difficulty"
    t.index ["quest_id"], name: "index_courses_on_quest_id"
    t.index ["uuid"], name: "index_courses_on_uuid", unique: true
  end

  create_table "false_answers", force: :cascade do |t|
    t.bigint "question_id"
    t.string "answer", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.uuid "uuid", null: false
    t.index ["question_id"], name: "index_false_answers_on_question_id"
    t.index ["uuid"], name: "index_false_answers_on_uuid", unique: true
  end

  create_table "feedback_issues", force: :cascade do |t|
    t.bigint "user_feedback_id", null: false
    t.string "issue", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["issue"], name: "index_feedback_issues_on_issue"
    t.index ["user_feedback_id"], name: "index_feedback_issues_on_user_feedback_id"
  end

  create_table "questions", force: :cascade do |t|
    t.uuid "uuid", null: false
    t.bigint "stage_id"
    t.string "title", null: false
    t.string "answer", null: false
    t.text "explanation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "body", null: false
    t.integer "category", default: 0, null: false
    t.index ["stage_id"], name: "index_questions_on_stage_id"
    t.index ["uuid"], name: "index_questions_on_uuid", unique: true
  end

  create_table "quests", force: :cascade do |t|
    t.uuid "uuid", null: false
    t.string "name"
    t.text "description"
    t.integer "state", limit: 2, default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["state"], name: "index_quests_on_state"
    t.index ["uuid"], name: "index_quests_on_uuid", unique: true
  end

  create_table "rankings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "rank", null: false
    t.integer "score", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["user_id", "rank"], name: "index_rankings_on_user_id_and_rank", unique: true
    t.index ["user_id"], name: "index_rankings_on_user_id"
  end

  create_table "stages", force: :cascade do |t|
    t.uuid "uuid", null: false
    t.bigint "course_id"
    t.string "prefix", null: false
    t.string "overview"
    t.string "target"
    t.integer "failed_case", default: 0, null: false
    t.integer "state", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "complete_case", default: 0, null: false
    t.datetime "deleted_at"
    t.index ["course_id"], name: "index_stages_on_course_id"
    t.index ["prefix"], name: "index_stages_on_prefix", unique: true
    t.index ["state"], name: "index_stages_on_state"
    t.index ["uuid"], name: "index_stages_on_uuid", unique: true
  end

  create_table "user_feedbacks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_id"
    t.bigint "question_id"
    t.text "details"
    t.text "other"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_user_feedbacks_on_course_id"
    t.index ["question_id"], name: "index_user_feedbacks_on_question_id"
    t.index ["user_id"], name: "index_user_feedbacks_on_user_id"
  end

  create_table "user_high_scores", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "total_high_scores", default: 0, null: false
    t.integer "cumulative_clear_stage_count", default: 0, null: false
    t.integer "consecutive_correct_answers", default: 0, null: false
    t.integer "highest_rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["user_id"], name: "index_user_high_scores_on_user_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.uuid "uuid", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

  create_table "words", force: :cascade do |t|
    t.bigint "question_id"
    t.string "name", null: false
    t.string "synonyms"
    t.integer "order_index", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["name"], name: "index_words_on_name"
    t.index ["question_id"], name: "index_words_on_question_id"
  end

  add_foreign_key "courses", "quests", on_delete: :nullify
  add_foreign_key "false_answers", "questions", on_delete: :nullify
  add_foreign_key "feedback_issues", "user_feedbacks"
  add_foreign_key "questions", "stages", on_delete: :nullify
  add_foreign_key "rankings", "users"
  add_foreign_key "stages", "courses", on_delete: :nullify
  add_foreign_key "user_feedbacks", "courses"
  add_foreign_key "user_feedbacks", "questions"
  add_foreign_key "user_feedbacks", "users"
  add_foreign_key "user_high_scores", "users"
  add_foreign_key "words", "questions", on_delete: :nullify
end
