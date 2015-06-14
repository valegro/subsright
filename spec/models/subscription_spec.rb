require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:subscription) { build(:subscription) }
  it { expect(subscription).to belong_to(:customer) }
  it { expect(subscription).to belong_to(:publication) }
  it { expect(subscription).to have_many(:payments) }
  it { expect(subscription).to have_db_column(:subscribed).of_type(:date).with_options(null: false) }
  it { expect(subscription).to have_db_column(:expiry).of_type(:date) }
  it { expect(subscription).to have_db_index([:customer_id, :publication_id]).unique }
  it { expect(subscription).to accept_nested_attributes_for(:customer) }
  it { expect(subscription).to accept_nested_attributes_for(:publication) }
  it { expect(subscription).to validate_presence_of(:publication) }
  it { expect(subscription).to validate_presence_of(:subscribed) }
  it { expect(subscription).to be_valid }
  it 'orders records by publication name' do
    b = create(:subscription, publication: create(:publication, name: 'B'))
    a = create(:subscription, publication: create(:publication, name: 'A'))
    subs = Subscription.all.by_name
    expect(subs.index(a)).to be < subs.index(b)
  end
end
