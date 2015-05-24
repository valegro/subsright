FactoryGirl.define do
  factory :offer_product do
    association :offer, strategy: :build
    association :product, strategy: :build
  end
end
