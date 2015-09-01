require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:subscription) { build(:subscription) }
  it { expect(subscription).to belong_to(:publication) }
  it { expect(subscription).to accept_nested_attributes_for(:publication) }
  it { expect(subscription).to belong_to(:user) }
  it { expect(subscription).to have_many(:renewals) }
  it { expect(subscription).to have_many(:customer_subscriptions) }
  it { expect(subscription).to have_many(:customers).through(:customer_subscriptions) }
  it { expect(subscription).to have_db_column(:subscribers).of_type(:integer).with_options(null: false) }
  it { expect(subscription).to have_db_column(:subscribed).of_type(:date).with_options(null: false) }
  it { expect(subscription).to have_db_column(:expiry).of_type(:date) }
  it { expect(subscription).to have_db_index(:publication_id) }
  it { expect(subscription).to have_db_index(:user_id) }
  it { expect(subscription).to validate_presence_of(:publication) }
  it { expect(subscription).to validate_presence_of(:subscribers) }
  it { expect(subscription).to validate_numericality_of(:subscribers).only_integer.is_greater_than(0) }
  it { expect(subscription).to validate_presence_of(:subscribed) }
  it { expect(subscription).to be_valid }
  it 'orders records by publication name' do
    b = create(:subscription, publication: create(:publication, name: 'B'))
    a = create(:subscription, publication: create(:publication, name: 'A'))
    subs = Subscription.all.by_name
    expect(subs.index(a)).to be < subs.index(b)
  end
  context 'formats subscriptions' do
    it('without subscribers') { expect(subscription.to_s).to eq "#{subscription.publication.name} (no subscribers)" }
    context 'with subscribers' do
      let(:customer) { build(:customer) }
      let(:description) { "#{subscription.publication.name} for #{customer.name}" }
      before { create(:customer_subscription, customer: customer, subscription: subscription) }
      it 'when a group subscription' do
        subscription.subscribers = 2
        expect(subscription.to_s).to eq "#{subscription.publication.name} for 2 subscribers (permanent)"
      end
      it('without expiry') { expect(subscription.to_s).to eq "#{description} (permanent)" }
      it 'when cancelled' do
        subscription.cancellation_reason = 'Test'
        subscription.expiry = Time.zone.today
        expect(subscription.to_s).to eq "#{description} (cancelled on #{I18n.l Time.zone.today, format: :long})"
      end
      it 'when expired' do
        subscription.expiry = Time.zone.today
        expect(subscription.to_s).to eq "#{description} (expired on #{I18n.l Time.zone.today, format: :long})"
      end
      it 'when current' do
        subscription.expiry = Time.zone.tomorrow
        expect(subscription.to_s).to eq "#{description} (expires on #{I18n.l Time.zone.tomorrow, format: :long})"
      end
    end
  end
end
