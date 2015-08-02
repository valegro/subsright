require 'rails_helper'

RSpec.feature 'Show use profile', type: :feature do
  context 'when not signed in' do
    scenario 'redirect to sign in page' do
      visit profile_path
      expect(current_path).to eq new_user_session_path
    end
  end

  context 'when signed in' do
    given(:now) { Time.zone.now }
    given(:user) { create(:user, confirmed_at: now) }
    before { login_as user }

    scenario 'see user name' do
      visit profile_path
      expect(page).to have_text user.name
    end

    scenario 'see unconfirmed email' do
      user.update_attributes! unconfirmed_email: 'test@example.com'
      visit profile_path
      expect(page).to have_text 'test@example.com'
    end

    scenario 'see time zone' do
      user.update_attributes! time_zone: 'Melbourne'
      visit profile_path
      expect(page).to have_text 'Melbourne'
    end

    scenario 'see currency' do
      user.update_attributes! currency: 'BTC'
      visit profile_path
      expect(page).to have_text 'Bitcoin'
    end
  end
end
