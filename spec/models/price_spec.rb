require 'rails_helper'

RSpec.describe Price, type: :model do
  let(:price) { build(:price) }
  it { expect(price).to have_db_column(:currency).of_type(:string).with_options(null: false) }
  it { expect(price).to have_db_column(:name).of_type(:string).with_options(null: false) }
  it { expect(price).to have_db_column(:amount_cents).of_type(:integer).with_options(null: false) }
  it { expect(price).to have_db_column(:monthly_payments).of_type(:integer) }
  it { expect(price).to have_db_column(:initial_amount_cents).of_type(:integer) }
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
  it { expect(price).to validate_numericality_of(:monthly_payments).allow_nil.only_integer.is_greater_than(0) }
  it { expect(price).to be_valid }
  it 'formats amounts' do
    price.amount = '123:456'
    expect(price.amount).to eq '$1,234.56'
  end
  it 'translates currency names' do
    price.currency = 'BTC'
    expect(price.currency_name).to eq 'Bitcoin (BTC)'
  end
  it 'formats initial amounts' do
    price.initial_amount = '123:456'
    expect(price.initial_amount).to eq '$1,234.56'
  end
  context 'formats prices' do
    context 'without initial amount' do
      let(:price) { build(:price, amount_cents: 123) }
      it 'without monthly payments'  do
        expect(price.to_s).to eq "#{price.name} $1.23 AUD"
      end
      it 'with monthly payments' do
        price.monthly_payments = 4
        expect(price.to_s).to eq "#{price.name} 4 monthly payments of $1.23 AUD each"
      end
    end
    context 'with initial amount' do
      let(:price) { build(:price, amount_cents: 456, initial_amount_cents: 123) }
      it 'without monthly payments' do
        expect(price.to_s).to eq "#{price.name} $1.23 AUD now, followed by $4.56 AUD"
      end
      it 'with monthly payments' do
        price.monthly_payments = 7
        expect(price.to_s).to eq "#{price.name} $1.23 AUD now, followed by 7 monthly payments of $4.56 AUD each"
      end
    end
  end
end
