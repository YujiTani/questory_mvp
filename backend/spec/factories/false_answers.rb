FactoryBot.define do
  factory :false_answer do
    question
    answer { "False Answer" }

    trait :deleted do
      deleted_at { Time.current }
    end
  end
end
