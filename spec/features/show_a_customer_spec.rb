require 'rails_helper'

RSpec.feature 'Show a customer', type: :feature do
  context 'when not signed in' do
    scenario 'redirect to sign in page' do
      visit customers_path
      expect(current_path).to eq new_user_session_path
    end
  end

  context 'when signed in' do
    given(:user) { create(:user, confirmed_at: Time.now) }
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
      scenario 'see each discount name' do
        discount1 = create(:discount)
        discount2 = create(:discount)
        create(:customer_discount, customer: customer, discount: discount1)
        create(:customer_discount, customer: customer, discount: discount2)
        visit customer_path(customer)
        expect(page).to have_text discount1.name
        expect(page).to have_text discount2.name
      end
    end

    context 'when there are no publications' do
      scenario 'see no publications' do
        visit customer_path(customer)
        expect(page).not_to have_text 'Publications:'
      end
    end

    context 'when there are publications' do
      scenario 'get a link to each publication' do
        publication1 = create(:publication)
        publication2 = create(:publication)
        create(:customer_publication, customer: customer, publication: publication1)
        create(:customer_publication, customer: customer, publication: publication2)
        visit customer_path(customer)
        expect(page).to have_link publication1.name, href: publication1.website
        expect(page).to have_link publication2.name, href: publication2.website
      end
    end
  end
end
