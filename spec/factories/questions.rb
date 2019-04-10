FactoryBot.define do
  sequence :title do |n|
    "Title#{n}"
  end

  factory :question do
    title { "QuestionTitle" }
    body { "QuestionBody" }

    trait :list do
      title
    end

    trait :invalid do
      title { nil }
    end
  end
end
