FactoryBot.define do
  factory :vote do
    votable { create(:question) }
    user { nil }
    value { 1 }
  end
end
