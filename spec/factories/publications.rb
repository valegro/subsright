require 'faker'

FactoryGirl.define do
  factory :publication do
    name { Faker::Lorem.sentence }
    website { Faker::Internet.url }
    api_key { Devise.friendly_token }
  end
end
