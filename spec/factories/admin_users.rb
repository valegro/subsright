require 'faker'

FactoryGirl.define do
  factory :admin_user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    sign_in_count { Faker::Number.number(6) }
    confirmed_at { Faker::Date.backward }
    failed_attempts { Faker::Number.number(6) }
  end
end
