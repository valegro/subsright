FactoryGirl.define do
  factory :customer_discount do
    association :customer, strategy: :build
    association :discount, strategy: :build
  end
end
