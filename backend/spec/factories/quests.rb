FactoryBot.define do
  factory :quest do
    sequence(:name) { |n| "Quest #{n}" }
    description { "This is a test quest description" }

    trait :published do
      state { :published }
    end

    trait :archived do
      state { :archived }
    end

    trait :deleted do
      deleted_at { Time.current }
    end
  end
end
