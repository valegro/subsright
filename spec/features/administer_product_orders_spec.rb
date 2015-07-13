require 'rails_helper'

RSpec.feature 'Administer product order', type: :feature do
  scenario 'requires login' do
    visit admin_product_orders_path
    expect(current_path).to eq new_admin_user_session_path
  end

  context 'when logged in' do
    given(:admin_user) { create :admin_user, confirmed_at: Time.zone.now }
    given(:product_order) { create :product_order }
    background do
      product_order
      login_as admin_user, scope: :admin_user
    end

    context 'when showing index' do
      background { visit admin_product_orders_path }
      [ :customer, :purchase, :product, :shipped, :created_at, :updated_at ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
      context 'when purchase is pending' do
        scenario('does not show Shipped action') { expect(page).not_to have_css '.table_actions a', text: 'Shipped' }
      end
      context 'when purchase is complete' do
        background do
          product_order.purchase.update! completed_at: Time.zone.now, receipt: rand(1000)
          visit admin_product_orders_path
        end
        scenario('shows Shipped action') { expect(page).to have_css '.table_actions a', text: 'Shipped' }
      end
      scenario('filters by customer')        { expect(page).to have_field 'q_customer_id' }
      scenario('filters by product')         { expect(page).to have_field 'q_product_id' }
      scenario('filters by shipped time')    { expect(page).to have_field 'q_shipped_gteq' }
      scenario('filters by creation time')   { expect(page).to have_field 'q_created_at_gteq' }
      scenario('filters by update time')     { expect(page).to have_field 'q_updated_at_gteq' }
    end

    context 'when viewing record' do
      background { visit admin_product_order_path(product_order) }
      [ :customer, :purchase, :product, :shipped, :created_at, :updated_at ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
      context 'when purchase is pending' do
        scenario('does not show Shipped button') { expect(page).not_to have_css 'form.edit_product_order' }
      end
      context 'when purchase is complete' do
        background do
          product_order.purchase.update! completed_at: Time.zone.now, receipt: rand(1000)
          visit admin_product_order_path(product_order)
        end
        scenario('shows Shipped button') { expect(page).to have_css 'form.edit_product_order' }
      end
    end
  end
end
