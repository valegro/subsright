require 'rails_helper'

RSpec.feature 'Administer campaign', type: :feature do
  scenario 'require login' do
    visit admin_campaigns_path
    expect(current_path).to eq new_admin_user_session_path
  end

  context 'when logged in' do
    given(:admin_user) { create(:admin_user, confirmed_at: Time.zone.now) }
    given(:campaign) { create(:campaign) }
    background do
      campaign
      login_as admin_user, scope: :admin_user
    end

    context 'when showing index' do
      background { visit admin_campaigns_path }
      [ :name, :start, :finish, :offers, :created_at, :updated_at ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
      scenario('filter by name')          { expect(page).to have_field 'q_name' }
      scenario('filter by start')         { expect(page).to have_field 'q_start_gteq' }
      scenario('filter by finish')        { expect(page).to have_field 'q_finish_gteq' }
      scenario('filter by offer')         { expect(page).to have_field 'q_offer_ids' }
      scenario('filter by creation time') { expect(page).to have_field 'q_created_at_gteq' }
      scenario('filter by update time')   { expect(page).to have_field 'q_updated_at_gteq' }
    end

    context 'when viewing record' do
      background { visit admin_campaign_path(campaign) }
      [ :name, :start, :finish, :offers, :description, :created_at, :updated_at ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
    end

    context 'when editing record' do
      background do
        visit edit_admin_campaign_path(campaign)
      end
      scenario { expect(page).to have_field 'campaign_name' }
      scenario { expect(page).to have_field 'campaign_start' }
      scenario { expect(page).to have_field 'campaign_finish' }
      scenario { expect(page).to have_css 'li#campaign_offers_input' }
      scenario { expect(page).to have_field 'campaign_description' }
    end
  end
end
