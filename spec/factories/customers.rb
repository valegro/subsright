require 'faker'

FactoryGirl.define do
  factory :customer do
    association :user, strategy: :build
    name { Faker::Name.name }
  end
end
