FactoryGirl.define do
  factory :user do
    uid { SecureRandom.uuid.gsub(/-/,'') }
    name { Faker::Name.name }
    email { Faker::Internet.email }
    oauth_token { SecureRandom.hex(10) }
    oauth_token_secret { SecureRandom.hex(5) }
    time_zone { "Asia/Yerevan" }
  end
end
