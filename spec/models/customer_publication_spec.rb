require 'rails_helper'

RSpec.describe CustomerPublication, type: :model do
  let(:customer_publication) { build(:customer_publication) }
  it { expect(customer_publication).to belong_to(:customer) }
  it { expect(customer_publication).to belong_to(:publication) }
  it { expect(customer_publication).to have_db_column(:subscribed).of_type(:date).with_options(null: false) }
  it { expect(customer_publication).to have_db_column(:expiry).of_type(:date) }
  it { expect(customer_publication).to have_db_index([:customer_id, :publication_id]).unique }
  it { expect(customer_publication).to accept_nested_attributes_for(:customer) }
  it { expect(customer_publication).to accept_nested_attributes_for(:publication) }
  it { expect(customer_publication).to validate_presence_of(:publication) }
  it { expect(customer_publication).to validate_presence_of(:subscribed) }
  it { expect(customer_publication).to be_valid }
  it 'orders records by publication name' do
    b = create(:customer_publication, publication: create(:publication, name: 'B'))
    a = create(:customer_publication, publication: create(:publication, name: 'A'))
    cps = CustomerPublication.all.by_name
    expect(cps.index(a)).to be < cps.index(b)
  end
end
