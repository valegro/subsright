require 'faker'

FactoryGirl.define do
  factory :customer_publication do
    association :customer, strategy: :build
    association :publication, strategy: :build
    subscribed { Faker::Date.backward }
  end
end
