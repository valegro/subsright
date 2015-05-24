require 'rails_helper'

RSpec.describe CustomerDiscount, type: :model do
  let(:customer_discount) { build(:customer_discount) }
  it { expect(customer_discount).to belong_to(:customer) }
  it { expect(customer_discount).to belong_to(:discount) }
  it { expect(customer_discount).to have_db_column(:reference).of_type(:string) }
  it { expect(customer_discount).to have_db_column(:expiry).of_type(:date) }
  it { expect(customer_discount).to have_db_index([:customer_id, :discount_id]).unique }
  it { expect(customer_discount).to accept_nested_attributes_for(:customer) }
  it { expect(customer_discount).to accept_nested_attributes_for(:discount) }
  it { expect(customer_discount).to validate_presence_of(:discount) }
  it { expect(customer_discount).to be_valid }
  it 'orders records by discount name' do
    b = create(:customer_discount, discount: create(:discount, name: 'B'))
    a = create(:customer_discount, discount: create(:discount, name: 'A'))
    cds = CustomerDiscount.all.by_name
    expect(cds.index(a)).to be < cds.index(b)
  end
end
