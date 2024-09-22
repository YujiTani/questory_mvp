FactoryBot.define do
  factory :stage do
    sequence(:prefix) { |n| "ST #{n}" }
    overview { "This is a test stage overview" }
    target { "beginner" }
    state { 0 }
    failed_case { 0 }
    complete_case { 0 }

    trait :published do
      state { 1 }
    end

    trait :archived do
      state { 2 }
    end

    trait :deleted do
      deleted_at { Time.current }
    end
  end
end
