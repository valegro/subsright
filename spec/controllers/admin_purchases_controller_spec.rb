require 'rails_helper'

RSpec.describe Admin::PurchasesController, type: :controller do
  let(:admin_user) { create(:admin_user, confirmed_at: Time.zone.now) }
  before { sign_in admin_user }
  let(:purchase) { create(:purchase) }

  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns @purchases' do
      get :index
      expect(assigns(:purchases)).to eq [purchase]
    end
    it('renders the index template') { expect(get :index).to render_template('index') }
  end

  describe 'GET #show' do
    it('responds successfully') { expect(get :show, id: purchase).to be_success }
    it 'assigns the requested purchase to @purchase' do
      get :show, id: purchase
      expect(assigns(:purchase)).to eq purchase
    end
    it('renders the show template') { expect(get :show, id: purchase).to render_template('show') }
  end
end
