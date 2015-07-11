require 'rails_helper'

RSpec.feature 'Administer dashboard', type: :feature do
  scenario 'require login' do
    visit admin_dashboard_path
    expect(current_path).to eq new_admin_user_session_path
  end

  context 'when logged in' do
    given(:admin_user) { create(:admin_user, confirmed_at: Time.zone.now) }
    background { login_as admin_user, scope: :admin_user }

    context 'when showing index' do
      background { visit admin_dashboard_path }
      scenario { expect(page).to have_text 'Welcome to Active Admin.' }
    end
  end
end
