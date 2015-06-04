require 'rails_helper'

RSpec.feature 'View offers', type: :feature do
  scenario 'get a link to each offer that has a price' do
    offer1 = create(:offer)
    offer2 = create(:offer)
    offer3 = create(:offer)
    price = create(:price)
    create(:offer_price, offer: offer1, price: price)
    create(:offer_price, offer: offer3, price: price)
    visit offers_path
    expect(page).to have_link offer1.name, href: offer_path(offer1)
    expect(page).not_to have_text offer2.name
    expect(page).to have_link offer3.name, href: offer_path(offer3)
  end
end
