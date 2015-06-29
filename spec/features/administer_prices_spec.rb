require 'rails_helper'

RSpec.feature 'Administer price', type: :feature do
  scenario 'require login' do
    visit admin_prices_path
    expect(current_path).to eq new_admin_user_session_path
  end

  context 'when logged in' do
    given(:admin_user) { create(:admin_user, confirmed_at: Time.zone.now) }
    given(:price) { create(:price) }
    background do
      price
      login_as admin_user, scope: :admin_user
    end

    context 'when showing index' do
      background { visit admin_prices_path }
      [ :currency, :name, :amount, :monthly_payments, :initial_amount, :created_at, :updated_at ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
      scenario('filter by currency')          { expect(page).to have_field 'q_currency' }
      scenario('filter by name')              { expect(page).to have_field 'q_name' }
      scenario('filter by amount')            { expect(page).to have_field 'q_amount_cents' }
      scenario('filter by monthly_payments')  { expect(page).to have_field 'q_monthly_payments' }
      scenario('filter by initial amount')    { expect(page).to have_field 'q_initial_amount_cents' }
      scenario('filter by creation time')     { expect(page).to have_field 'q_created_at_gteq' }
      scenario('filter by update time')       { expect(page).to have_field 'q_updated_at_gteq' }
    end

    context 'when viewing record' do
      background { visit admin_price_path(price) }
      [ :currency, :name, :amount, :monthly_payments, :initial_amount, :created_at, :updated_at ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
    end

    context 'when editing record' do
      background do
        visit edit_admin_price_path(price)
      end
      scenario { expect(page).to have_field 'price_currency' }
      scenario { expect(page).to have_field 'price_name' }
      scenario { expect(page).to have_field 'price_amount' }
      scenario { expect(page).to have_field 'price_monthly_payments' }
      scenario { expect(page).to have_field 'price_initial_amount' }
    end
  end
end
