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
    let(:product1) { create(:product) }
    let(:product2) { create(:product) }
    let(:offer_product1) { create(:offer_product, offer: offer, product: product1, optional: true) }
    let(:offer_product2) { create(:offer_product, offer: offer, product: product2) }
    before { get :show, id: offer }
    it('responds successfully') { expect(response).to be_success }
    it('assigns the requested offer to @offer') { expect(assigns(:offer)).to eq offer }
    it 'assigns included offer_products to @included_products' do
      expect(assigns(:included_products)).to eq [offer_product2]
    end
    it 'assigns optional offer_products to @optional_products' do
      expect(assigns(:optional_products)).to eq [offer_product1]
    end
    it('renders the show template') { expect(response).to render_template('show') }
  end
end
