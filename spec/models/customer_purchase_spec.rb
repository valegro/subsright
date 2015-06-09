require 'rails_helper'

RSpec.describe CustomerPurchase, type: :model do
  let(:customer_purchase) { build(:customer_purchase) }
  it { expect(customer_purchase).to belong_to(:customer) }
  it { expect(customer_purchase).to belong_to(:purchase) }
  it { expect(customer_purchase).to have_db_index([:customer_id, :purchase_id]).unique }
  it { expect(customer_purchase).to validate_presence_of(:customer) }
  it { expect(customer_purchase).to validate_presence_of(:purchase) }
  it { expect(customer_purchase).to be_valid }
end
