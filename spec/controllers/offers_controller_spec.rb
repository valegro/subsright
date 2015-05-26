require 'rails_helper'

RSpec.describe OffersController, type: :controller do
  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns @offers in order of finish' do
      offer1 = create(:offer, finish: Time.zone.today + 2.days)
      offer2 = create(:offer, finish: Time.zone.today + 1.day)
      get :index
      expect(assigns(:offers)).to eq [offer2, offer1]
    end
    it('renders the index template') { expect(get :index).to render_template('index') }
  end

  describe 'GET #show' do
    let(:offer) { create(:offer) }
    it('responds successfully') { expect(get :show, id: offer).to be_success }
    it 'assigns the requested offer to @offer' do
      get :show, id: offer
      expect(assigns(:offer)).to eq offer
    end
    it('renders the show template') { expect(get :show, id: offer).to render_template('show') }
  end
end
