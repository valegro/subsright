require 'faker'

FactoryGirl.define do
  factory :customer do
    name { Faker::Name.name }
  end
end
