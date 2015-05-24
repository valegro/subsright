FactoryGirl.define do
  factory :campaign_offer do
    association :campaign, strategy: :build
    association :offer, strategy: :build
  end
end
