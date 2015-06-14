require 'faker'

FactoryGirl.define do
  factory :payment do
    association :purchase, strategy: :build
    association :subscription, strategy: :build
    price_name { Faker::Lorem.sentence }
  end
end
