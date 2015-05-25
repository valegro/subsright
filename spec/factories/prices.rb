require 'faker'

FactoryGirl.define do
  factory :price do
    currency 'AUD'
    name { Faker::Lorem.sentence }
    amount_cents { Faker::Number.number(6) }
  end
end
