require 'rails_helper'

RSpec.feature 'Administer subscription', type: :feature do
  scenario 'require login' do
    visit admin_subscriptions_path
    expect(current_path).to eq new_admin_user_session_path
  end

  context 'when logged in' do
    given(:admin_user) { create(:admin_user, confirmed_at: Time.zone.now) }
    given(:subscription) { create(:subscription) }
    background do
      subscription
      login_as admin_user, scope: :admin_user
    end

    context 'when showing index' do
      background { visit admin_subscriptions_path }
      [ :publication, :user, :subscribers, :subscribed, :expiry, :cancellation_reason, :created_at, :updated_at
      ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
      scenario('filter by publication')         { expect(page).to have_field 'q_publication_id' }
      scenario('filter by user')                { expect(page).to have_field 'q_user_id' }
      scenario('filter by subscribers')         { expect(page).to have_field 'q_subscribers' }
      scenario('filter by subscribed')          { expect(page).to have_field 'q_subscribed_gteq' }
      scenario('filter by expiry')              { expect(page).to have_field 'q_expiry_gteq' }
      scenario('filter by cancellation reason') { expect(page).to have_field 'q_cancellation_reason' }
      scenario('filter by customer')            { expect(page).to have_field 'q_customer_ids' }
      scenario('filter by creation time')       { expect(page).to have_field 'q_created_at_gteq' }
      scenario('filter by update time')         { expect(page).to have_field 'q_updated_at_gteq' }
    end

    context 'when viewing record' do
      background { visit admin_subscription_path(subscription) }
      [ :publication, :user, :subscribers, :subscribed, :expiry, :cancellation_reason, :customers, :purchases,
        :created_at, :updated_at ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
    end

    context 'when editing record' do
      background do
        visit edit_admin_subscription_path(subscription)
      end
      scenario { expect(page).to have_field 'subscription_publication_id' }
      scenario { expect(page).to have_field 'subscription_user_id' }
      scenario { expect(page).to have_field 'subscription_subscribers' }
      scenario { expect(page).to have_field 'subscription_subscribed' }
      scenario { expect(page).to have_field 'subscription_expiry' }
      scenario { expect(page).to have_field 'subscription_cancellation_reason' }
      scenario { expect(page).to have_css :li, text: 'Customers' }
    end
  end
end
