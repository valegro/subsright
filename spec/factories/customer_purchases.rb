FactoryGirl.define do
  factory :customer_purchase do
    association :customer, strategy: :build
    association :purchase, strategy: :build
  end
end
