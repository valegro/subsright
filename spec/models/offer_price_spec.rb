require 'rails_helper'

RSpec.describe OfferPrice, type: :model do
  let(:offer_price) { build(:offer_price) }
  it { expect(offer_price).to belong_to(:offer) }
  it { expect(offer_price).to belong_to(:price) }
  it { expect(offer_price).to have_db_index([:offer_id, :price_id]).unique }
  it { expect(offer_price).to be_valid }
end
