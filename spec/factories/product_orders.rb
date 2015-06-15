FactoryGirl.define do
  factory :product_order do
    association :customer, strategy: :build
    association :purchase, strategy: :build
    association :product, strategy: :build
  end
end
