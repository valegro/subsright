require 'rails_helper'

RSpec.describe OffersController, type: :controller do
  describe 'GET #index' do
    let(:price) { create(:price) }
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns @offers in order of finish' do
      offer1 = create(:offer, finish: Time.zone.today + 2.days)
      create(:offer) # No price
      offer2 = create(:offer, finish: Time.zone.today + 1.day)
      create(:offer_price, offer: offer1, price: price)
      create(:offer_price, offer: offer2, price: price)
      get :index
      expect(assigns(:offers)).to eq [offer2, offer1]
    end
    it('renders the index template') { expect(get :index).to render_template('index') }
  end

  describe 'GET #show' do
    let(:offer) { create(:offer) }
    context 'when there are no prices' do
      it 'redirects to the index page' do
        get :show, id: offer
        expect(response).to redirect_to offers_path
      end
    end
    context 'when there is at least one price' do
      let(:price) { create(:price) }
      let(:offer_price) { create(:offer_price, offer: offer, price: price) }
      let(:product) { create(:product) }
      let(:offer_product) { create(:offer_product, offer: offer, product: product) }
      before do
        offer_price
        offer_product
        get :show, id: offer
      end
      it('responds successfully') { expect(response).to be_success }
      it('assigns the requested offer to @offer') { expect(assigns(:offer)).to eq offer }
      it('assigns offer products to @products') { expect(assigns(:products)).to eq [offer_product] }
    end
    context 'when signed in' do
      let(:price) { create(:price) }
      let(:offer_price) { create(:offer_price, offer: offer, price: price) }
      let(:user) { create(:user, confirmed_at: Time.zone.now, currency: 'BTC') }
      let(:customer) { create(:customer, email: user.email, name: user.name) }
      before do
        offer_price
        customer
        sign_in user
        get :show, id: offer
      end
      it("assigns the user's currency") { expect(assigns(:purchase).currency).to eq 'BTC' }
      it('assigns the matching customer') { expect(assigns(:customer)).to eq customer }
    end
  end

  describe 'POST #purchase' do
    let(:offer) { create(:offer) }
    context 'when there is no offer' do
      before { post :purchase, id: '' }
      it('redirects to the index page') { expect(response).to redirect_to offers_path }
    end
    context 'when there is no price' do
      before { post :purchase, id: offer, purchase: { customer: { name: 'Test' } } }
      it('assigns the requested offer to @offer') { expect(assigns(:offer)).to eq offer }
      it('assigns the customer params to @customer') { expect(assigns(:customer).name).to eq 'Test' }
      it('renders the show template') { expect(response).to render_template('show') }
    end
  end
end
