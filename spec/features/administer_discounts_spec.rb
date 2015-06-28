require 'rails_helper'

RSpec.feature 'Administer discount', type: :feature do
  scenario 'require login' do
    visit admin_discounts_path
    expect(current_path).to eq new_admin_user_session_path
  end

  context 'when logged in' do
    given(:admin_user) { create(:admin_user, confirmed_at: Time.zone.now) }
    given(:discount) { create(:discount) }
    background do
      discount
      login_as admin_user, scope: :admin_user
    end

    context 'when showing index' do
      background { visit admin_discounts_path }
      [ :name, :requestable, :prices, :created_at, :updated_at ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
      scenario('filter by name')          { expect(page).to have_field 'q_name' }
      scenario('filter by requestable')   { expect(page).to have_field 'q_requestable' }
      scenario('filter by price')         { expect(page).to have_field 'q_price_ids' }
      scenario('filter by creation time') { expect(page).to have_field 'q_created_at_gteq' }
      scenario('filter by update time')   { expect(page).to have_field 'q_updated_at_gteq' }
    end

    context 'when viewing record' do
      background { visit admin_discount_path(discount) }
      [ :name, :requestable, :prices, :created_at, :updated_at ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
    end

    context 'when editing record' do
      background do
        visit edit_admin_discount_path(discount)
      end
      scenario { expect(page).to have_field 'discount_name' }
      scenario { expect(page).to have_field 'discount_requestable' }
      scenario { expect(page).to have_css :li, text: 'Prices' }
    end
  end
end
