require 'rails_helper'

RSpec.describe ProductOrder, type: :model do
  let(:product_order) { build(:product_order) }
  it { expect(product_order).to belong_to(:customer) }
  it { expect(product_order).to belong_to(:purchase) }
  it { expect(product_order).to belong_to(:product) }
  it { expect(product_order).to have_db_column(:shipped).of_type(:date) }
  it { expect(product_order).to have_db_index([:customer_id, :purchase_id, :product_id]).unique }
  it { expect(product_order).to have_db_index(:product_id) }
  it { expect(product_order).to validate_presence_of(:customer) }
  it { expect(product_order).to validate_presence_of(:purchase) }
  it { expect(product_order).to validate_presence_of(:product) }
  it { expect(product_order).to be_valid }
end
