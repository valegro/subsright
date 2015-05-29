require 'faker'

FactoryGirl.define do
  factory :customer do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    sign_in_count { Faker::Number.number(6) }
    failed_attempts { Faker::Number.number(6) }
  end
end
