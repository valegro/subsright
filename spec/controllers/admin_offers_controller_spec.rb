require 'rails_helper'
include Devise::TestHelpers

RSpec.describe Admin::OffersController, type: :controller do
  before { sign_in AdminUser.first }
  let(:offer) { create(:offer) }

  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns @offers' do
      get :index
      expect(assigns(:offers)).to eq [offer]
    end
    it('renders the index template') { expect(get :index).to render_template('index') }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new offer' do
        expect { post :create, offer: attributes_for(:offer) }.to change(Offer, :count).by(1)
      end
      it 'redirects to the new offer' do
        post :create, offer: attributes_for(:offer)
        expect(response).to redirect_to admin_offer_path(Offer.last)
      end
    end
    context 'with invalid attributes' do
      it 'does not save the new offer' do
        expect { post :create, offer: nil }.not_to change(Offer, :count)
      end
      it('re-renders the new method') { expect(post :create, offer: nil).to render_template('new') }
    end
  end

  describe 'GET #new' do
    it('responds successfully') { expect(get :new).to be_success }
    it('renders the new template') { expect(get :new).to render_template('new') }
  end

  describe 'GET #edit' do
    it('responds successfully') { expect(get :edit, id: offer).to be_success }
    it('renders the edit template') { expect(get :edit, id: offer).to render_template('edit') }
  end

  describe 'GET #show' do
    it('responds successfully') { expect(get :show, id: offer).to be_success }
    it 'assigns the requested offer to @offer' do
      get :show, id: offer
      expect(assigns(:offer)).to eq offer
    end
    it('renders the show template') { expect(get :show, id: offer).to render_template('show') }
  end

  describe 'PATCH #update' do
    before { offer }
    context 'with valid attributes' do
      it 'locates the requested offer' do
        patch :update, id: offer, offer: attributes_for(:offer)
        expect(assigns(:offer)).to eq offer
      end
      it "changes the offer's attributes" do
        new_attributes = attributes_for(:offer)
        patch :update, id: offer, offer: new_attributes
        offer.reload
        expect(offer.name).to eq new_attributes[:name]
      end
      it 'redirects to the updated offer' do
        patch :update, id: offer, offer: attributes_for(:offer)
        expect(response).to redirect_to admin_offer_path(offer)
      end
    end
    context 'with invalid attributes' do
      it 'locates the requested offer' do
        patch :update, id: offer, offer: nil
        expect(assigns(:offer)).to eq offer
      end
      it "does not change the offer's attributes" do
        name = offer.name
        patch :update, id: offer, offer: nil
        offer.reload
        expect(offer.name).to eq name
      end
      it 'redirects back to the offer' do
        patch :update, id: offer, offer: nil
        expect(response).to redirect_to admin_offer_path(offer)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { offer }
    it('deletes the offer') { expect { delete :destroy, id: offer }.to change(Offer, :count).by(-1) }
    it('redirects to offers#index') { expect(delete :destroy, id: offer).to redirect_to admin_offers_path }
  end

  describe 'POST #batch_action' do
    let(:offers) { [create(:offer), create(:offer)] }
    before { offers }
    it('deletes the offers') do
      expect do
        post :batch_action,
          batch_action: 'destroy',
          collection_selection_toggle_all: 'on',
          collection_selection: offers
      end.to change(Offer, :count).by(-2)
    end
    it('redirects to offers#index') do
      post :batch_action,
        batch_action: 'destroy',
        collection_selection_toggle_all: 'on',
        collection_selection: offers
      expect(response).to redirect_to admin_offers_path
    end
  end
end
