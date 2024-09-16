FactoryBot.define do
  factory :quest do
    uuid { SecureRandom.uuid }
    sequence(:name) { |n| "Quest #{n}" }
    description { "This is a test quest description" }
    state { :draft }

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
