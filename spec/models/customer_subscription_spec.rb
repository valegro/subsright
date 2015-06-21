require 'rails_helper'

RSpec.describe CustomerSubscription, type: :model do
  let(:customer_subscription) { build(:customer_subscription) }
  it { expect(customer_subscription).to belong_to(:customer) }
  it { expect(customer_subscription).to belong_to(:subscription) }
  it { expect(customer_subscription).to have_db_index([:customer_id, :subscription_id]).unique }
  it { expect(customer_subscription).to have_db_index([:subscription_id, :customer_id]).unique }
  it { expect(customer_subscription).to be_valid }
end
