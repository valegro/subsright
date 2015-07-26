require 'rails_helper'

RSpec.feature 'Show a customer', type: :feature do
  context 'when not signed in' do
    scenario 'redirect to sign in page' do
      visit customers_path
      expect(current_path).to eq new_user_session_path
    end
  end

  context 'when signed in' do
    given(:now) { Time.zone.now }
    given(:user) { create(:user, confirmed_at: now) }
    given(:customer) { create(:customer, user: user) }
    before { login_as user }

    scenario 'see customer name' do
      visit customer_path(customer)
      expect(page).to have_text customer.name
    end

    context 'when there are no discounts' do
      scenario 'see no discounts' do
        visit customer_path(customer)
        expect(page).not_to have_text 'Discounts:'
      end
    end

    context 'when there are discounts' do
      given(:discount1) { create(:discount) }
      given(:discount2) { create(:discount) }
      given(:cd1) { create(:customer_discount, customer: customer, discount: discount1) }
      given(:cd2) { create(:customer_discount, customer: customer, discount: discount2, expiry: now) }
      background do
        cd1
        cd2
        visit customer_path(customer)
      end
      scenario 'see each discount name' do
        expect(page).to have_text discount1.name
        expect(page).to have_text discount2.name
      end
      scenario 'see discount expiry dates' do
        expect(page).to have_text "(expires #{I18n.l cd2.expiry, format: :long})"
      end
    end

    context 'when there are no publications' do
      scenario 'see no publications' do
        visit customer_path(customer)
        expect(page).not_to have_text 'Publications:'
      end
    end

    context 'when there are publications' do
      given(:publication1) { create(:publication) }
      given(:publication2) { create(:publication) }
      given(:s1) { create(:subscription, publication: publication1) }
      given(:s2) { create(:subscription, publication: publication2, expiry: now) }
      background do
        create(:customer_subscription, customer: customer, subscription: s1)
        create(:customer_subscription, customer: customer, subscription: s2)
        visit customer_path(customer)
      end
      scenario 'get a link to each publication' do
        expect(page).to have_link publication1.name, href: publication1.website
        expect(page).to have_link publication2.name, href: publication2.website
      end
      scenario 'see publication expiry dates' do
        expect(page).to have_text "(expires #{I18n.l s2.expiry, format: :long})"
      end
    end
  end
end
