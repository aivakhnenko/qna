FactoryBot.define do
  sequence :name do |n|
    "RewardName#{n}"
  end

  factory :reward do
    name
    image { Rack::Test::UploadedFile.new(Rails.root.join('public', 'favicon.ico'), 'image/ico') }
  end
end
