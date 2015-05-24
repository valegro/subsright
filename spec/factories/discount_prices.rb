FactoryGirl.define do
  factory :discount_price do
    association :discount, strategy: :build
    association :price, strategy: :build
  end
end
