require 'rails_helper'

RSpec.feature 'Administer offer', type: :feature do
  scenario 'require login' do
    visit admin_offers_path
    expect(current_path).to eq new_admin_user_session_path
  end

  context 'when logged in' do
    given(:admin_user) { create(:admin_user, confirmed_at: Time.zone.now) }
    given(:offer) { create(:offer) }
    background do
      offer
      login_as admin_user, scope: :admin_user
    end

    context 'when showing index' do
      background { visit admin_offers_path }
      [ :name, :start, :finish, :trial_period, :campaigns, :publications, :products, :prices, :created_at, :updated_at
      ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
      scenario('filter by name')          { expect(page).to have_field 'q_name' }
      scenario('filter by start')         { expect(page).to have_field 'q_start_gteq' }
      scenario('filter by finish')        { expect(page).to have_field 'q_finish_gteq' }
      scenario('filter by trial period')  { expect(page).to have_field 'q_trial_period' }
      scenario('filter by campaign')      { expect(page).to have_field 'q_price_ids' }
      scenario('filter by publication')   { expect(page).to have_field 'q_publication_ids' }
      scenario('filter by product')       { expect(page).to have_field 'q_product_ids' }
      scenario('filter by price')         { expect(page).to have_field 'q_price_ids' }
      scenario('filter by creation time') { expect(page).to have_field 'q_created_at_gteq' }
      scenario('filter by update time')   { expect(page).to have_field 'q_updated_at_gteq' }
    end

    context 'when viewing record' do
      background { visit admin_offer_path(offer) }
      [ :name, :start, :finish, :trial_period, :campaigns, :publications, :products, :prices, :description,
        :created_at, :updated_at ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end

      context 'when there is an offer publication' do
        given(:offer_publication) { create(:offer_publication, offer: offer, publication: create(:publication)) }
        scenario 'show the subscription period' do
          offer_publication
          visit admin_offer_path(offer)
          expect(page).to have_text "for #{offer_publication.quantity} " +
            offer_publication.unit.downcase.pluralize(offer_publication.quantity)
        end
        scenario "don't mention a single subscriber" do
          offer_publication
          visit admin_offer_path(offer)
          expect(page).not_to have_text 'subscribers'
        end
        scenario 'show the number of subscribers for group subscriptions' do
          offer_publication.subscribers = 2
          offer_publication.save!
          visit admin_offer_path(offer)
          expect(page).to have_text 'for 2 subscribers'
        end
      end

      context 'when there are offer products' do
        given(:included_offer_product) { create(:offer_product, offer: offer, product: create(:product)) }
        given(:optional_offer_product) do
          create(:offer_product, offer: offer, product: create(:product), optional: true)
        end
        scenario 'show optional products after included products' do
          optional_offer_product
          included_offer_product
          visit admin_offer_path(offer)
          expect(page).to have_css 'li:first-child', text: included_offer_product.product.name
          expect(page).to have_css 'li:last-child', text: optional_offer_product.product.name + ' (optional)'
        end
      end
    end

    context 'when editing record' do
      background do
        visit edit_admin_offer_path(offer)
      end
      scenario { expect(page).to have_field 'offer_name' }
      scenario { expect(page).to have_field 'offer_start' }
      scenario { expect(page).to have_field 'offer_finish' }
      scenario { expect(page).to have_field 'offer_trial_period' }
      scenario { expect(page).to have_css :li, text: 'Campaigns' }
      scenario { expect(page).to have_css :li, text: 'Offer publications' }
      scenario { expect(page).to have_css :li, text: 'Offer products' }
      scenario { expect(page).to have_css :li, text: 'Prices' }
      scenario { expect(page).to have_field 'offer_description' }
    end
  end
end
