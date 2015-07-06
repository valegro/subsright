require 'rails_helper'

RSpec.feature 'Administer purchase', type: :feature do
  scenario 'require login' do
    visit admin_purchases_path
    expect(current_path).to eq new_admin_user_session_path
  end

  context 'when logged in' do
    given(:admin_user) { create :admin_user, confirmed_at: Time.zone.now }
    given(:purchase) { create :purchase }
    background do
      purchase
      login_as admin_user, scope: :admin_user
    end

    context 'when showing index' do
      background { visit admin_purchases_path }
      [ :offer, :currency, :amount, :completed_at, :receipt, :created_at, :updated_at ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
      scenario('filter by offer')           { expect(page).to have_field 'q_offer_id' }
      scenario('filter by products')        { expect(page).to have_field 'q_product_ids' }
      scenario('filter by currency')        { expect(page).to have_field 'q_currency' }
      scenario('filter by amount')          { expect(page).to have_field 'q_amount_cents' }
      scenario('filter by completion time') { expect(page).to have_field 'q_completed_at_gteq' }
      scenario('filter by receipt')         { expect(page).to have_field 'q_receipt' }
      scenario('filter by creation time')   { expect(page).to have_field 'q_created_at_gteq' }
      scenario('filter by update time')     { expect(page).to have_field 'q_updated_at_gteq' }
    end

    context 'when viewing record' do
      given(:customer) { create :customer }
      given(:product) { create :product }
      background { visit admin_purchase_path(purchase) }
      [ :offer, :currency, :amount, :completed_at, :receipt, :subscriptions, :products, :created_at, :updated_at
      ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
      scenario 'names associated customers and products' do
        create(:product_order, customer: customer, purchase: purchase, product: product)
        visit admin_purchase_path(purchase)
        expect(page).to have_text "#{product.name} for #{customer.name} (pending)"
      end
      scenario 'reports product order shipped dates' do
        create(:product_order, customer: customer, purchase: purchase, product: product, shipped: Time.zone.today)
        visit admin_purchase_path(purchase)
        expect(page).to have_text "(shipped #{I18n.l Time.zone.today})"
      end
    end
  end
end
