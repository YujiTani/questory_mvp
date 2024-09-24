FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "Question #{n}" }
    body { |n| "This is a test question #{n}" }
    answer { 'Good Answer' }
    explanation { '正解の解説' }
    category { :choice }

    trait :choice do
      category { :choice }
    end

    trait :multiple do
      category { :multiple }
    end

    trait :assembly do
      category { :assembly }
    end

    trait :deleted do
      deleted_at { Time.current }
    end
  end
end
