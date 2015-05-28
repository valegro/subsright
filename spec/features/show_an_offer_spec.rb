require 'rails_helper'
require 'faker'

RSpec.feature 'Show an offer', type: :feature do
  given(:offer) do
    create(:offer, description: Faker::Lorem.sentences.join("\s"), trial_period: Faker::Number.number(3))
  end
  scenario 'see offer name and description' do
    visit offer_path(offer)
    expect(page).to have_text offer.name
    expect(page).to have_text offer.description
  end

  context 'when there are publications' do
    given(:publication1) { create(:publication) }
    given(:publication2) { create(:publication) }
    background do
      create(:offer_publication, offer: offer, publication: publication1)
      create(:offer_publication, offer: offer, publication: publication2)
      visit offer_path(offer)
    end
    scenario 'get a link to each publication' do
      expect(page).to have_link publication1.name, href: publication_path(publication1)
      expect(page).to have_link publication2.name, href: publication_path(publication2)
    end
  end

  context 'when there are no products' do
    scenario 'do not see optional products' do
      visit offer_path(offer)
      expect(page).not_to have_text 'Plus one of:'
      expect(page).not_to have_text 'Choose one of:'
    end
  end

  context 'when there are products' do
    given(:product1) { create(:product) }
    given(:product2) { create(:product) }

    context 'when there are no optional products' do
      background do
        create(:offer_product, offer: offer, product: product1)
        create(:offer_product, offer: offer, product: product2)
        visit offer_path(offer)
      end
      scenario 'get a link to each product' do
        expect(page).to have_link product1.name, href: product_path(product1)
        expect(page).to have_link product2.name, href: product_path(product2)
      end
      scenario 'do not see optional products' do
        expect(page).not_to have_text 'Plus one of:'
        expect(page).not_to have_text 'Choose one of:'
      end
    end

    context 'when there are optional products' do
      background do
        create(:offer_product, offer: offer, product: product1, optional: true)
        create(:offer_product, offer: offer, product: product2)
        visit offer_path(offer)
      end
      scenario 'see optional products' do
        expect(page).to have_text 'Plus one of:'
      end
      scenario 'get a link to each product' do
        expect(page).to have_link product1.name, href: product_path(product1)
        expect(page).to have_link product2.name, href: product_path(product2)
      end
    end

    context 'when there are only optional products' do
      background do
        create(:offer_product, offer: offer, product: product1, optional: true)
        create(:offer_product, offer: offer, product: product2, optional: true)
        visit offer_path(offer)
      end
      scenario 'see optional products' do
        expect(page).to have_text 'Choose one of:'
      end
      scenario 'get a link to each product' do
        expect(page).to have_link product1.name, href: product_path(product1)
        expect(page).to have_link product2.name, href: product_path(product2)
      end
    end
  end

  context 'when there are prices' do
    given(:price1) { create(:price) }
    given(:price2) { create(:price) }
    background do
      create(:offer_price, offer: offer, price: price1)
      create(:offer_price, offer: offer, price: price2)
      visit offer_path(offer)
    end
    scenario 'see each price' do
      expect(page).to have_text "#{price1.name} #{price1.amount} #{price1.currency}"
      expect(page).to have_text "#{price2.name} #{price2.amount} #{price2.currency}"
    end
    scenario 'see the trial period' do
      expect(page).to have_text "#{offer.trial_period} day free trial"
    end
  end
end
