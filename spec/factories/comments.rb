FactoryBot.define do
  factory :comment do
    commentable { create(:question, user: create(:user)) }
    user { nil }
    text { "MyString" }
  end
end
