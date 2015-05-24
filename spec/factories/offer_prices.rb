FactoryGirl.define do
  factory :offer_price do
    association :offer, strategy: :build
    association :price, strategy: :build
  end
end
