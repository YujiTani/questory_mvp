FactoryBot.define do
  factory :course do
    sequence(:name) { |n| "Course #{n}" }
    description { 'This is a test course description' }
    difficulty { 0 }

    trait :nomal do
      difficulty { 1 }
    end

    trait :hard do
      difficulty { 2 }
    end

    trait :deleted do
      deleted_at { Time.current }
    end
  end
end
