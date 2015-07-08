require 'rails_helper'

RSpec.describe Purchase, type: :model do
  let(:purchase) { build(:purchase) }
  it { expect(purchase).to belong_to(:offer) }
  it { expect(purchase).to have_db_column(:currency).of_type(:string).with_options(null: false) }
  it { expect(purchase).to have_db_column(:amount_cents).of_type(:integer).with_options(null: false) }
  it { expect(purchase).to have_db_column(:completed_at).of_type(:datetime) }
  it { expect(purchase).to have_many(:payments) }
  it { expect(purchase).to have_many(:subscriptions).through(:payments) }
  it { expect(purchase).to have_many(:product_orders) }
  it { expect(purchase).to have_many(:products).through(:product_orders) }
  it { expect(purchase).to validate_presence_of(:offer) }
  it { expect(purchase).to be_valid }
  it 'formats amounts' do
    purchase.amount_cents = '123456'
    expect(purchase.amount).to eq '$1,234.56'
  end
  it 'translates currency names' do
    purchase.currency = 'BTC'
    expect(purchase.currency_name).to eq 'Bitcoin (BTC)'
  end
  it 'shows pending purchases' do
    expect(purchase.to_s).to eq "#{purchase.currency} #{purchase.amount} (pending)"
  end
  it 'shows completed purchases' do
    purchase.completed_at = Time.zone.now
    expect(purchase.to_s).to eq "#{purchase.currency} #{purchase.amount} (completed at " +
      I18n.l(purchase.completed_at, format: :long) + ')'
  end
end
