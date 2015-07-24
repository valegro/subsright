require 'rails_helper'
require 'faker'

RSpec.feature 'Show a campaign', type: :feature do
  given(:campaign) { create(:campaign, description: Faker::Lorem.sentences.join("\s")) }
  scenario 'see campaign name and description' do
    visit campaign_path(campaign)
    expect(page).to have_text campaign.name
    expect(page).to have_text campaign.description
  end

  context 'when there are offers' do
    scenario 'get a link to each offer' do
      offer1 = create(:offer)
      offer2 = create(:offer)
      create(:campaign_offer, campaign: campaign, offer: offer1)
      create(:campaign_offer, campaign: campaign, offer: offer2)
      visit campaign_path(campaign)
      expect(page).to have_link offer1.name, href: offer_path(offer1)
      expect(page).to have_link offer2.name, href: offer_path(offer2)
    end
  end
end
