FactoryBot.define do
  factory :comment do
    commentable { create(:question) }
    user
    text { "MyString" }
  end
end
