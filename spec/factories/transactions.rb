FactoryGirl.define do
  factory :transaction do
    association :purchase, strategy: :build
    message 'MyString'
  end
end
