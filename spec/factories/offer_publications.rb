FactoryGirl.define do
  factory :offer_publication do
    association :offer, strategy: :build
    association :publication, strategy: :build
    quantity 1
    unit 'Year'
  end
end
