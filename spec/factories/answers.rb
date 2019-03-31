FactoryBot.define do
  sequence :body do |n|
    "Body#{n}"
  end

  factory :answer do
    body { "MyText" }

    trait :list do
      body
    end

    trait :invalid do
      body { nil }
    end
  end
end
