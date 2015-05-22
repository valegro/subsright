require 'rails_helper'

RSpec.describe Campaign, type: :model do
  let(:campaign) { build(:campaign) }
  it { expect(campaign).to have_db_column(:name).of_type(:string).with_options(null: false) }
  it { expect(campaign).to have_db_column(:start).of_type(:date) }
  it { expect(campaign).to have_db_column(:finish).of_type(:date) }
  it { expect(campaign).to have_db_column(:description).of_type(:text) }
  it { expect(campaign).to have_many :campaign_offers }
  it { expect(campaign).to have_many(:offers).through(:campaign_offers) }
  it { expect(campaign).to accept_nested_attributes_for :offers }
  it { expect(campaign).to validate_presence_of :name }
  it { expect(campaign).to be_valid }
end
