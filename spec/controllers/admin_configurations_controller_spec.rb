require 'rails_helper'

RSpec.describe Admin::ConfigurationsController, type: :controller do
  let(:admin_user) { create(:admin_user, confirmed_at: Time.zone.now) }
  before { sign_in admin_user }

  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it('renders the index template') { expect(get :index).to render_template('index') }
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'changes the configuration attributes' do
        configuration = create(:configuration, key: 'provider_name')
        patch :update, id: 0, update_configuration: { provider_name: 'Test' }
        configuration.reload
        expect(configuration.value).to eq 'Test'
      end
    end
    it 'redirects to the updated configuration' do
      patch :update, id: 0, update_configuration: { key: 'value' }
      expect(response).to redirect_to admin_configurations_path
    end
  end
end
