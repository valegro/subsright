require 'rails_helper'

RSpec.describe CampaignOffer, type: :model do
  let(:campaign_offer) { build(:campaign_offer) }
  it { expect(campaign_offer).to belong_to(:campaign) }
  it { expect(campaign_offer).to belong_to(:offer) }
  it { expect(campaign_offer).to have_db_index([:campaign_id, :offer_id]).unique }
  it { expect(campaign_offer).to be_valid }
end
