require 'rails_helper'

RSpec.feature 'Administer admin users', type: :feature do
  scenario 'require login' do
    visit admin_admin_users_path
    expect(current_path).to eq new_admin_user_session_path
  end

  context 'when logged in' do
    given(:admin_user) { create(:admin_user, confirmed_at: Time.zone.now) }
    background { login_as admin_user, scope: :admin_user }

    context 'when showing index' do
      background { visit admin_admin_users_path }
      [ :name, :email, :time_zone, :current_sign_in_at, :sign_in_count, :created_at, :updated_at ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
      scenario('filter by name')                  { expect(page).to have_field 'q_name' }
      scenario('filter by email')                 { expect(page).to have_field 'q_email' }
      scenario('filter by time zone')             { expect(page).to have_field 'q_time_zone' }
      scenario('filter by current sign in time')  { expect(page).to have_field 'q_current_sign_in_at_gteq' }
      scenario('filter by sign in count')         { expect(page).to have_field 'q_sign_in_count' }
      scenario('filter by creation time')         { expect(page).to have_field 'q_created_at_gteq' }
      scenario('filter by update time')           { expect(page).to have_field 'q_updated_at_gteq' }
    end

    context 'when viewing record' do
      background { visit admin_admin_user_path(admin_user) }
      [ :name, :email, :unconfirmed_email, :time_zone, :confirmation_sent_at, :confirmed_at, :reset_password_sent_at,
        :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip,
        :last_sign_in_ip, :failed_attempts, :locked_at, :created_at, :updated_at ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
    end

    context 'when editing record' do
      background { visit edit_admin_admin_user_path(admin_user) }
      scenario { expect(page).to have_field 'admin_user_name' }
      scenario { expect(page).to have_field 'admin_user_email' }
      scenario { expect(page).to have_field 'admin_user_time_zone' }
    end
  end
end
