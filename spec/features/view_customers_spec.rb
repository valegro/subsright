require 'rails_helper'

RSpec.feature 'View customers', type: :feature do
  context 'when not signed in' do
    scenario 'redirect to sign in page' do
      visit customers_path
      expect(current_path).to eq new_user_session_path
    end
  end
  context 'when signed in' do
    given(:user) { create(:user, confirmed_at: Time.now) }
    before { login_as user }
    scenario 'get a link to each customer' do
      customer1 = create(:customer, user: user)
      customer2 = create(:customer)
      customer3 = create(:customer, user: user)
      visit customers_path
      expect(page).to have_link customer1.name, href: customer_path(customer1)
      expect(page).to have_link customer3.name, href: customer_path(customer3)
    end
  end
end
