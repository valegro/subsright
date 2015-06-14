FactoryGirl.define do
  factory :purchase do
    association :offer, strategy: :build
    currency 'AUD'
    amount_cents 0
  end
end
