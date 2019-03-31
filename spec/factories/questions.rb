FactoryBot.define do
  sequence :title do |n|
    "Title#{n}"
  end

  factory :question do
    title { "MyString" }
    body { "MyText" }

    trait :list do
      title
    end

    trait :invalid do
      title { nil }
    end
  end
end
