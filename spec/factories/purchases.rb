require 'faker'

FactoryGirl.define do
  factory :purchase do
    association :offer, strategy: :build
    price_name { Faker::Lorem.sentence }
    currency 'AUD'
    amount_cents { Faker::Number.number(6) }
  end
end
