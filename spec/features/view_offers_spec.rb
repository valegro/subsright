require 'rails_helper'

RSpec.feature 'View offers', type: :feature do
  scenario 'get a link to each offer' do
    offer1 = create(:offer)
    offer2 = create(:offer)
    visit offers_path
    expect(page).to have_link offer1.name, href: offer_path(offer1)
    expect(page).to have_link offer2.name, href: offer_path(offer2)
  end
end
