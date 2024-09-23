FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "Question #{n}" }
    body { |n| "This is a test question #{n}" }
    answer { "Good Answer" }
    category { 0 }
    explanation { "正解の解説" }

    trait :choice do
      category { 0 }
    end

    trait :multiple do
      category { 1 }
    end

    trait :assembly do
      category { 2 }
    end

    trait :deleted do
      deleted_at { Time.current }
    end
  end
end
