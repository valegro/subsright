require 'rails_helper'

RSpec.feature 'Administer product', type: :feature do
  scenario 'require login' do
    visit admin_products_path
    expect(current_path).to eq new_admin_user_session_path
  end

  context 'when logged in' do
    given(:admin_user) { create :admin_user, confirmed_at: Time.zone.now }
    given(:product) { create :product }
    background do
      product
      login_as admin_user, scope: :admin_user
    end

    context 'when showing index' do
      background { visit admin_products_path }
      [ :name, :image, :stock, :shipped, :unshipped, :offers, :created_at, :updated_at ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
      scenario('filter by name')                { expect(page).to have_field 'q_name' }
      scenario('filter by image update time')   { expect(page).to have_field 'q_image_updated_at_gteq' }
      scenario('filter by stock')               { expect(page).to have_field 'q_stock' }
      scenario('filter by shipped count')       { expect(page).to have_field 'q_shipped_count' }
      scenario('filter by unshipped count')     { expect(page).to have_field 'q_unshipped_count' }
      scenario('filter by offer')               { expect(page).to have_field 'q_offer_ids' }
      scenario('filter by creation time')       { expect(page).to have_field 'q_created_at_gteq' }
      scenario('filter by update time')         { expect(page).to have_field 'q_updated_at_gteq' }
      scenario 'show product thumbnails' do
        product.update! image: File.new( Rails.root.join( *%w(app assets images subscriptus-logo.png) ) )
        visit admin_products_path
        expect(page).to have_css 'img[alt="Subscriptus logo"]'
      end
      scenario 'show shipped count' do
        create :product_order, product: product, shipped: Time.zone.today
        ProductOrder.counter_culture_fix_counts
        visit admin_products_path
        expect(page).to have_css 'td.col-shipped', text: '1'
      end
      scenario 'show unshipped count' do
        create :product_order, product: product
        ProductOrder.counter_culture_fix_counts
        visit admin_products_path
        expect(page).to have_css 'td.col-unshipped', text: '1'
      end
    end

    context 'when viewing record' do
      background { visit admin_product_path(product) }
      [ :name, :image, :stock, :offers, :product_orders, :description, :created_at, :updated_at ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
      scenario 'show the product image' do
        product.update! image: File.new( Rails.root.join( *%w(app assets images subscriptus-logo.png) ) )
        visit admin_product_path(product)
        expect(page).to have_css 'img[alt="Subscriptus logo"]'
      end
    end

    context 'when editing record' do
      background do
        visit edit_admin_product_path(product)
      end
      scenario { expect(page).to have_field 'product_name' }
      scenario { expect(page).to have_field 'product_image' }
      scenario { expect(page).to have_field 'product_stock' }
      scenario { expect(page).to have_field 'product_description' }
    end
  end
end
