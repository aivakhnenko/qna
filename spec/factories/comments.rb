FactoryBot.define do
  factory :comment do
    commentable { nil }
    user { nil }
    text { "MyString" }
  end
end
