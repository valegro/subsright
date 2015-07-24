require 'rails_helper'
require 'faker'

RSpec.feature 'Show a product', type: :feature do
  given(:product) { create(:product, description: Faker::Lorem.sentences.join("\s")) }
  scenario 'see product image' do
    visit product_path(product)
    expect(page).to have_css "img[alt='#{product.name}']"
  end
  scenario 'see product name and description' do
    visit product_path(product)
    expect(page).to have_text product.name
    expect(page).to have_text product.description
  end

  context 'when there are no offers' do
    scenario 'see "Not presently available"' do
      visit product_path(product)
      expect(page).to have_text 'Not presently available'
    end
  end

  context 'when there are offers' do
    given(:offer1) { create(:offer) }
    given(:offer2) { create(:offer) }
    background do
      create(:offer_product, product: product, offer: offer1)
      create(:offer_product, product: product, offer: offer2)
      visit product_path(product)
    end
    scenario 'get a link to each offer' do
      expect(page).to have_link offer1.name, href: offer_path(offer1)
      expect(page).to have_link offer2.name, href: offer_path(offer2)
    end
  end
end
