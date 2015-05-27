require 'rails_helper'

RSpec.feature 'View campaigns', type: :feature do
  scenario 'get a link to each campaign' do
    campaign1 = create(:campaign)
    campaign2 = create(:campaign)
    visit campaigns_path
    expect(page).to have_link campaign1.name, href: campaign_path(campaign1)
    expect(page).to have_link campaign2.name, href: campaign_path(campaign2)
  end
end
