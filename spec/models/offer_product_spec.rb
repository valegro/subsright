require 'rails_helper'

RSpec.describe OfferProduct, type: :model do
  let(:offer_product) { build(:offer_product) }
  it { expect(offer_product).to belong_to(:offer) }
  it { expect(offer_product).to belong_to(:product) }
  it { expect(offer_product).to have_db_column(:optional).of_type(:boolean).with_options(null: false) }
  it { expect(offer_product).to have_db_index([:offer_id, :product_id]).unique }
  it { expect(offer_product).to accept_nested_attributes_for(:offer) }
  it { expect(offer_product).to accept_nested_attributes_for(:product) }
  it { expect(offer_product).to validate_presence_of(:product) }
  it { expect(offer_product).to be_valid }
  it 'orders records by product name' do
    b = create(:offer_product, product: create(:product, name: 'B'))
    a = create(:offer_product, product: create(:product, name: 'A'))
    ops = OfferProduct.all.by_name
    expect(ops.index(a)).to be < ops.index(b)
  end
end
