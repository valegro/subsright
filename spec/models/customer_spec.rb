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
  it { expect(customer).to have_db_index([:email, :name]) }
  it { expect(customer).to have_many(:customer_discounts) }
  it { expect(customer).to accept_nested_attributes_for(:customer_discounts).allow_destroy(true) }
  it { expect(customer).to have_many(:discounts).through(:customer_discounts) }
  it { expect(customer).to accept_nested_attributes_for(:discounts) }
  it { expect(customer).to have_many(:subscriptions) }
  it { expect(customer).to accept_nested_attributes_for(:subscriptions).allow_destroy(true) }
  it { expect(customer).to have_many(:publications).through(:subscriptions) }
  it { expect(customer).to accept_nested_attributes_for(:publications) }
  it { expect(customer).to have_many(:subscriptions) }
  it { expect(customer).to have_many(:payments).through(:subscriptions) }
  it { expect(customer).to have_many(:purchases).through(:payments) }
  it { expect(customer).to validate_presence_of(:name) }
  it { expect(customer).to be_valid }
  it('allows multiple customers with the same name') do
    customer1 = create(:customer)
    customer2 = build(:customer, name: customer1.name)
    expect(customer2).to be_valid
  end
  it('allows multiple customers with the same email') do
    customer1 = create(:customer, email: 'test@example.com')
    customer2 = build(:customer, email: customer1.email)
    expect(customer2).to be_valid
  end
  it('does not allow multiple customers with the same name and email') do
    customer1 = create(:customer, email: 'test@example.com')
    customer2 = build(:customer, name: customer1.name, email: customer1.email)
    expect(customer2).not_to be_valid
  end
  it('translates country names') do
    customer.country = 'DE'
    expect(customer.country_name).to eq 'Germany'
  end
end
