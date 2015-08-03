require 'rails_helper'

RSpec.describe Admin::ConfigurationsController, type: :controller do
  let(:admin_user) { create(:admin_user, confirmed_at: Time.zone.now) }
  before { sign_in admin_user }

  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it('renders the index template') { expect(get :index).to render_template('index') }
  end

  describe 'PATCH #update' do
    before { Configuration.ensure_created }
    context 'with valid attributes' do
      it 'changes the configuration attributes' do
        patch :update, id: 0, update_configuration: { provider_name: 'Test' }
        expect(Configuration.find_by(key: :provider_name).value).to eq 'Test'
      end
    end
    it 'redirects to the updated configuration' do
      patch :update, id: 0, update_configuration: { key: 'value' }
      expect(response).to redirect_to admin_configurations_path
    end
  end
end
