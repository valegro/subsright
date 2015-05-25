require 'faker'

FactoryGirl.define do
  factory :price do
    currency 'AUD'
    name { Faker::Lorem.sentence }
    amount { Faker::Number.number(6) }
  end
end
