require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do
  let(:admin_user) { create(:admin_user, confirmed_at: Time.zone.now) }
  before { sign_in admin_user }

  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it('renders the index template') { expect(get :index).to render_template('index') }
  end
end
