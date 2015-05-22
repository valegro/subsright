require 'faker'

FactoryGirl.define do
  factory :offer do
    name { Faker::Lorem.sentence }
  end
end
