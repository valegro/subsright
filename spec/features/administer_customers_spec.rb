require 'rails_helper'

RSpec.feature 'Administer customer', type: :feature do
  scenario 'require login' do
    visit admin_customers_path
    expect(current_path).to eq new_admin_user_session_path
  end

  context 'when logged in' do
    given(:admin_user) { create(:admin_user, confirmed_at: Time.zone.now) }
    given(:customer) { create(:customer) }
    background do
      customer
      login_as admin_user, scope: :admin_user
    end

    context 'when showing index' do
      background { visit admin_customers_path }
      [ :user, :name, :email, :phone, :address, :country, :postcode, :discounts, :publications, :created_at,
        :updated_at ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
      scenario('filter by user')          { expect(page).to have_field 'q_user_id' }
      scenario('filter by name')          { expect(page).to have_field 'q_name' }
      scenario('filter by email')         { expect(page).to have_field 'q_email' }
      scenario('filter by phone')         { expect(page).to have_field 'q_phone' }
      scenario('filter by address')       { expect(page).to have_field 'q_address' }
      scenario('filter by country')       { expect(page).to have_field 'q_country' }
      scenario('filter by postcode')      { expect(page).to have_field 'q_postcode' }
      scenario('filter by discount')      { expect(page).to have_field 'q_discount_ids' }
      scenario('filter by publication')   { expect(page).to have_field 'q_publication_ids' }
      scenario('filter by creation time') { expect(page).to have_field 'q_created_at_gteq' }
      scenario('filter by update time')   { expect(page).to have_field 'q_updated_at_gteq' }
    end

    context 'when viewing record' do
      background { visit admin_customer_path(customer) }
      [ :user, :name, :email, :phone, :address, :country, :postcode, :discounts, :publications, :product_orders,
        :created_at, :updated_at ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
    end

    context 'when editing record' do
      background do
        visit edit_admin_customer_path(customer)
      end
      scenario { expect(page).to have_field 'customer_user_id' }
      scenario { expect(page).to have_field 'customer_name' }
      scenario { expect(page).to have_field 'customer_email' }
      scenario { expect(page).to have_field 'customer_phone' }
      scenario { expect(page).to have_field 'customer_address' }
      scenario { expect(page).to have_field 'customer_country' }
      scenario { expect(page).to have_field 'customer_postcode' }
      scenario { expect(page).to have_css :li, text: 'Customer discounts' }
      scenario { expect(page).to have_css :li, text: 'Subscriptions' }
    end
  end
end
