require 'rails_helper'

RSpec.describe Offer, type: :model do
  let(:offer) { build(:offer) }
  it { expect(offer).to have_db_column(:name).of_type(:string).with_options(null: false) }
  it { expect(offer).to have_db_column(:start).of_type(:date) }
  it { expect(offer).to have_db_column(:finish).of_type(:date) }
  it { expect(offer).to have_db_column(:trial_period).of_type(:integer) }
  it { expect(offer).to have_db_column(:description).of_type(:text) }
  it { expect(offer).to have_many :campaign_offers }
  it { expect(offer).to have_many(:campaigns).through(:campaign_offers) }
  it { expect(offer).to accept_nested_attributes_for(:campaigns) }
  it { expect(offer).to have_many :offer_products }
  it { expect(offer).to accept_nested_attributes_for(:offer_products).allow_destroy(true) }
  it { expect(offer).to have_many(:products).through(:offer_products) }
  it { expect(offer).to accept_nested_attributes_for(:products) }
  it { expect(offer).to have_many :offer_publications }
  it { expect(offer).to accept_nested_attributes_for(:offer_publications).allow_destroy(true) }
  it { expect(offer).to have_many(:publications).through(:offer_publications) }
  it { expect(offer).to accept_nested_attributes_for(:publications) }
  it { expect(offer).to have_many :offer_prices }
  it { expect(offer).to have_many(:prices).through(:offer_prices) }
  it { expect(offer).to accept_nested_attributes_for(:prices) }
  it { expect(offer).to have_many :purchases }
  it { expect(offer).to validate_presence_of :name }
  it { expect(offer).to validate_numericality_of(:trial_period).allow_nil.only_integer.is_greater_than(0) }
end
