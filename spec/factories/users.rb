FactoryGirl.define do
  factory :user do
    uid { SecureRandom.uuid }
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end
