FactoryBot.define do
  sequence :body do |n|
    "AnswerBody#{n}"
  end

  factory :answer do
    body

    trait :invalid do
      body { nil }
    end

    after(:build) do |answer|
      answer.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb')
    end
  end
end
