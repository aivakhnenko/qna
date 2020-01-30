FactoryBot.define do
  factory :vote do
    votable { create(:question, user: create(:user)) }
    user { nil }
    value { 1 }
  end
end
