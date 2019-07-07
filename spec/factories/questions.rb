FactoryBot.define do
  sequence :title do |n|
    "QuestionTitle#{n}"
  end

  factory :question do
    title
    body { "QuestionBody" }

    trait :invalid do
      title { nil }
    end

    after(:build) do |question|
      question.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb')
      question.links.new(name: 'My link', url: 'https://www.google.com')
    end
  end
end
