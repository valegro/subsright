FactoryGirl.define do
  factory :customer_subscription do
    association :customer, strategy: :build
    association :subscription, strategy: :build
  end
end
