FactoryBot.define do
  sequence :body do |n|
    "AnswerBody#{n}"
  end

  factory :answer do
    body
    question
    user

    trait :invalid do
      body { nil }
    end

    trait :with_file_attached do
      after(:create) do |answer|
        answer.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb')
      end
    end

    trait :with_file_attached do
      after(:create) do |answer|
        answer.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb')
        answer.files.attach(io: File.open(Rails.root.join('spec', 'spec_helper.rb')), filename: 'spec_helper.rb')
      end
    end
  end
end
