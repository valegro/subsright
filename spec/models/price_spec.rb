require 'rails_helper'

RSpec.describe Price, type: :model do
  let(:price) { build(:price) }
  it { expect(price).to have_db_column(:currency).of_type(:string).with_options(null: false) }
  it { expect(price).to have_db_column(:name).of_type(:string).with_options(null: false) }
  it { expect(price).to have_db_column(:amount_cents).of_type(:integer).with_options(null: false) }
  it { expect(price).to have_db_index([:currency, :name]).unique }
  it { expect(price).to have_many(:offer_prices) }
  it { expect(price).to have_many(:offers).through(:offer_prices) }
  it { expect(price).to accept_nested_attributes_for(:offers) }
  it { expect(price).to have_many(:discount_prices) }
  it { expect(price).to have_many(:discounts).through(:discount_prices) }
  it { expect(price).to accept_nested_attributes_for(:discounts) }
  it { expect(price).to validate_presence_of(:currency) }
  it { expect(price).to validate_presence_of(:name) }
  it { expect(price).to validate_uniqueness_of(:name).scoped_to(:currency) }
  it { expect(price).to validate_presence_of(:amount_cents) }
  it { expect(price).to be_valid }
  it('formats amounts') do
    price.amount = '123:456'
    expect(price.amount).to eq '$1,234.56'
  end
  it('translates currency names') do
    price.currency = 'BTC'
    expect(price.currency_name).to eq 'Bitcoin (BTC)'
  end
end
