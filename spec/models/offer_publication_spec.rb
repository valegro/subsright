require 'rails_helper'

RSpec.describe OfferPublication, type: :model do
  let(:offer_publication) { build(:offer_publication) }
  it { expect(offer_publication).to belong_to(:offer) }
  it { expect(offer_publication).to belong_to(:publication) }
  it { expect(offer_publication).to have_db_column(:quantity).of_type(:integer).with_options(null: false) }
  it { expect(offer_publication).to have_db_column(:unit).of_type(:string).with_options(null: false) }
  it { expect(offer_publication).to have_db_index([:offer_id, :publication_id]).unique }
  it { expect(offer_publication).to accept_nested_attributes_for(:offer) }
  it { expect(offer_publication).to accept_nested_attributes_for(:publication) }
  it { expect(offer_publication).to validate_presence_of(:publication) }
  it { expect(offer_publication).to validate_presence_of(:quantity) }
  it { expect(offer_publication).to validate_numericality_of(:quantity).only_integer.is_greater_than(0) }
  it { expect(offer_publication).to validate_presence_of(:unit) }
  it { expect(offer_publication).to be_valid }
  it 'orders records by publication name' do
    b = create(:offer_publication, publication: create(:publication, name: 'B'))
    a = create(:offer_publication, publication: create(:publication, name: 'A'))
    ops = OfferPublication.all.by_name
    expect(ops.index(a)).to be < ops.index(b)
  end
end
