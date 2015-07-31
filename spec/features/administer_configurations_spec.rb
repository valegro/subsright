require 'rails_helper'

RSpec.feature 'Administer configuration', type: :feature do
  scenario 'require login' do
    visit admin_configurations_path
    expect(current_path).to eq new_admin_user_session_path
  end

  context 'when logged in' do
    given(:admin_user) { create(:admin_user, confirmed_at: Time.zone.now) }
    background do
      Configuration
      login_as admin_user, scope: :admin_user
      visit admin_configurations_path
    end
    Configuration.settings.each do |setting|
      scenario { expect(page).to have_field "update_configuration_#{setting}" }
    end
  end
end
