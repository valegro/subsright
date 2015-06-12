require 'rails_helper'

RSpec.describe Customer, type: :model do
  let(:customer) { build(:customer) }
  it { expect(customer).to belong_to(:user) }
  it { expect(customer).to have_db_column(:name).of_type(:string).with_options(null: false) }
  it { expect(customer).to have_db_column(:email).of_type(:string) }
  it { expect(customer).to have_db_column(:phone).of_type(:string) }
  it { expect(customer).to have_db_column(:address).of_type(:text) }
  it { expect(customer).to have_db_column(:country).of_type(:string) }
  it { expect(customer).to have_db_column(:postcode).of_type(:string) }
  it { expect(customer).to have_db_column(:currency).of_type(:string) }
  it { expect(customer).to have_many(:customer_discounts) }
  it { expect(customer).to accept_nested_attributes_for(:customer_discounts).allow_destroy(true) }
  it { expect(customer).to have_many(:discounts).through(:customer_discounts) }
  it { expect(customer).to accept_nested_attributes_for(:discounts) }
  it { expect(customer).to have_many(:subscriptions) }
  it { expect(customer).to accept_nested_attributes_for(:subscriptions).allow_destroy(true) }
  it { expect(customer).to have_many(:publications).through(:subscriptions) }
  it { expect(customer).to accept_nested_attributes_for(:publications) }
  it { expect(customer).to have_many(:customer_purchases) }
  it { expect(customer).to have_many(:purchases).through(:customer_purchases) }
  it { expect(customer).to validate_presence_of(:name) }
  it { expect(customer).to be_valid }
  it('translates country names') do
    customer.country = 'DE'
    expect(customer.country_name).to eq 'Germany'
  end
  it('translates currency names') do
    customer.currency = 'BTC'
    expect(customer.currency_name).to eq 'Bitcoin (BTC)'
  end
end
