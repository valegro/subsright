require 'faker'

FactoryGirl.define do
  factory :subscription do
    association :publication, strategy: :build
    subscribers 1
    subscribed { Faker::Date.backward }
  end
end
