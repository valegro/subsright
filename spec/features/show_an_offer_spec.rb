require 'rails_helper'
require 'faker'

RSpec.feature 'Show an offer', type: :feature do
  given(:offer) do
    create(:offer, description: Faker::Lorem.sentences.join("\s"), trial_period: 1 + rand(100))
  end
  context 'when there are no prices' do
    scenario 'redirect to list of offers' do
      visit offer_path(offer)
      expect(current_path).to eq offers_path
    end
  end

  context 'when there is at least one price' do
    given(:price1) { create(:price) }
    given(:price2) { create(:price, initial_amount_cents: 1 + rand(1000)) }
    background do
      create(:offer_price, offer: offer, price: price1)
      create(:offer_price, offer: offer, price: price2)
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
        scenario('see optional products') { expect(page).to have_text 'Plus one of:' }
        scenario 'get a link to each product' do
          expect(page).to have_link product1.name, href: product_path(product1)
          expect(page).to have_link product2.name, href: product_path(product2)
        end
      end

      context 'when there are publications and optional products' do
        background do
          create(:offer_publication, offer: offer, publication: create(:publication))
          create(:offer_product, offer: offer, product: product1, optional: true)
          visit offer_path(offer)
        end
        scenario('see optional products') { expect(page).to have_text 'Plus one of:' }
      end

      context 'when there are only optional products' do
        background do
          create(:offer_product, offer: offer, product: product1, optional: true)
          create(:offer_product, offer: offer, product: product2, optional: true)
          visit offer_path(offer)
        end
        scenario('see optional products') { expect(page).to have_text 'Choose one of:' }
        scenario 'get a link to each product' do
          expect(page).to have_link product1.name, href: product_path(product1)
          expect(page).to have_link product2.name, href: product_path(product2)
        end
      end
    end

    scenario 'see each price' do
      visit offer_path(offer)
      expect(page).to have_text "#{price1.name}: #{price1.amount} #{price1.currency}"
      expect(page).to have_text "#{price2.name}: #{price2.initial_amount} #{price2.currency}"
    end

    scenario 'see the trial period' do
      visit offer_path(offer)
      expect(page).to have_text "#{offer.trial_period} day free trial"
    end
  end
end
