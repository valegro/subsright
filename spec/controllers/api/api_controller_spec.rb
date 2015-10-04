require 'rails_helper'

RSpec.describe Api::ApiController, type: :controller do
  describe 'GET #version' do
    before { get :version, format: :json }
    it('responds successfully') { expect(response).to be_success }
    it('returns version') { expect(JSON.parse response.body).to eq 'version' => 1 }
  end
end
