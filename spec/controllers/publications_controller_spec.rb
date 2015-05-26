require 'rails_helper'

RSpec.describe PublicationsController, type: :controller do
  let(:publication) { create(:publication) }

  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns @publications' do
      get :index
      expect(assigns(:publications)).to eq [publication]
    end
    it('renders the index template') { expect(get :index).to render_template('index') }
  end

  describe 'GET #show' do
    it('responds successfully') { expect(get :show, id: publication).to be_success }
    it 'assigns the requested publication to @publication' do
      get :show, id: publication
      expect(assigns(:publication)).to eq publication
    end
    it('renders the show template') { expect(get :show, id: publication).to render_template('show') }
  end
end
