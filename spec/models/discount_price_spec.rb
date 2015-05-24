require 'rails_helper'

RSpec.describe DiscountPrice, type: :model do
  let(:discount_price) { build(:discount_price) }
  it { expect(discount_price).to belong_to(:discount) }
  it { expect(discount_price).to belong_to(:price) }
  it { expect(discount_price).to have_db_index([:discount_id, :price_id]).unique }
  it { expect(discount_price).to be_valid }
end
