require 'rails_helper'

RSpec.describe Campaign, type: :model do
  let(:campaign) { build :campaign }
  it { expect(campaign).to have_db_column(:name).of_type(:string).with_options(null: false) }
  it { expect(campaign).to have_db_column(:start).of_type(:date) }
  it { expect(campaign).to have_db_column(:finish).of_type(:date) }
  it { expect(campaign).to have_db_column(:description).of_type(:text) }
  it { expect(campaign).to have_many :campaign_offers }
  it { expect(campaign).to have_many(:offers).through(:campaign_offers) }
  it { expect(campaign).to accept_nested_attributes_for :offers }
  it { expect(campaign).to validate_presence_of :name }
  it { expect(campaign).to be_valid }
  context 'destroys campaigns' do
    let(:offer) { create :offer }
    let(:campaign) { create :campaign }
    let(:campaign_offer) { create :campaign_offer, campaign: campaign, offer: offer }
    it 'with no offers' do
      campaign
      expect { campaign.destroy }.to change(Campaign, :count).by(-1)
    end
    it 'with inactive offer' do
      campaign_offer
      expect { campaign.destroy }.to change(Campaign, :count).by(-1)
    end
    it 'with future offer' do
      offer.start = Time.zone.tomorrow
      offer.save!
      campaign_offer
      expect { campaign.destroy }.to change(Campaign, :count).by(-1)
    end
    it 'with past offer' do
      offer.finish = Time.zone.yesterday
      offer.save!
      campaign_offer
      expect { campaign.destroy }.to change(Campaign, :count).by(-1)
    end
  end
  it 'does not destroy campaigns with an active offer' do
    campaign = create :campaign
    offer = create :offer, start: Time.zone.yesterday, finish: Time.zone.tomorrow
    create :campaign_offer, campaign: campaign, offer: offer
    expect { campaign.destroy }.to change(Campaign, :count).by(0)
  end
end
