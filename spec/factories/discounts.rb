require 'faker'

FactoryGirl.define do
  factory :discount do
    name { Faker::Lorem.sentence }
  end
end
