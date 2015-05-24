require 'faker'

FactoryGirl.define do
  factory :publication do
    name { Faker::Lorem.sentence }
    website { Faker::Internet.url }
  end
end
