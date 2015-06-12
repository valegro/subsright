require 'faker'

FactoryGirl.define do
  factory :subscription do
    association :customer, strategy: :build
    association :publication, strategy: :build
    subscribed { Faker::Date.backward }
  end
end
