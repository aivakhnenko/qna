FactoryBot.define do
  sequence :title do |n|
    "QuestionTitle#{n}"
  end

  factory :question do
    title
    body { "QuestionBody" }
    user

    trait :invalid do
      title { nil }
    end

    trait :with_file_attached do
      after(:create) do |question|
        question.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb')
      end
    end

    trait :with_files_attached do
      after(:create) do |question|
        question.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb')
        question.files.attach(io: File.open(Rails.root.join('spec', 'spec_helper.rb')), filename: 'spec_helper.rb')
      end
    end
  end
end
