require 'faker'

FactoryGirl.define do
  factory :configuration do
    key { Faker::Lorem.word }
    form_type { Faker::Lorem.word }
  end
end
