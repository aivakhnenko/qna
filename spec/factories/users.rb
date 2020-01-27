FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }
    confirmed_at { Time.now.utc }

    trait :omniauth_tmp do
      email { "omniauth_tmp_#{Devise.friendly_token[0, 20]}@omniauth_tmp.tmp" }
    end
  end
end
