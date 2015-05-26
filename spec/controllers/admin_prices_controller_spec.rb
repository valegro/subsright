require 'rails_helper'
include Devise::TestHelpers

RSpec.describe Admin::PricesController, type: :controller do
  before { sign_in AdminUser.first }
  let(:price) { create(:price) }
  let(:invalid_attributes) { attributes_for(:price, name: nil) }

  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns @prices' do
      get :index
      expect(assigns(:prices)).to eq [price]
    end
    it('renders the index template') { expect(get :index).to render_template('index') }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new price' do
        expect { post :create, price: attributes_for(:price) }.to change(Price, :count).by(1)
      end
      it 'redirects to the new price' do
        post :create, price: attributes_for(:price)
        expect(response).to redirect_to admin_price_path(Price.last)
      end
    end
    context 'with invalid attributes' do
      it 'does not save the new price' do
        expect { post :create, price: invalid_attributes }.not_to change(Price, :count)
      end
      it('re-renders the new template') { expect(post :create, price: invalid_attributes).to render_template('new') }
    end
  end

  describe 'GET #new' do
    it('responds successfully') { expect(get :new).to be_success }
    it('renders the new template') { expect(get :new).to render_template('new') }
  end

  describe 'GET #edit' do
    it('responds successfully') { expect(get :edit, id: price).to be_success }
    it('renders the edit template') { expect(get :edit, id: price).to render_template('edit') }
  end

  describe 'GET #show' do
    it('responds successfully') { expect(get :show, id: price).to be_success }
    it 'assigns the requested price to @price' do
      get :show, id: price
      expect(assigns(:price)).to eq price
    end
    it('renders the show template') { expect(get :show, id: price).to render_template('show') }
  end

  describe 'PATCH #update' do
    before { price }
    context 'with valid attributes' do
      it 'locates the requested price' do
        patch :update, id: price, price: attributes_for(:price)
        expect(assigns(:price)).to eq price
      end
      it "changes the price's attributes" do
        new_attributes = attributes_for(:price)
        patch :update, id: price, price: new_attributes
        price.reload
        expect(price.name).to eq new_attributes[:name]
      end
      it 'redirects to the updated price' do
        patch :update, id: price, price: attributes_for(:price)
        expect(response).to redirect_to admin_price_path(price)
      end
    end
    context 'with invalid attributes' do
      it 'locates the requested price' do
        patch :update, id: price, price: invalid_attributes
        expect(assigns(:price)).to eq price
      end
      it "does not change the price's attributes" do
        name = price.name
        patch :update, id: price, price: invalid_attributes
        price.reload
        expect(price.name).to eq name
      end
      it 're-renders the edit template' do
        expect(patch :update, id: price, price: invalid_attributes).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    before { price }
    it('deletes the price') { expect { delete :destroy, id: price }.to change(Price, :count).by(-1) }
    it('redirects to prices#index') { expect(delete :destroy, id: price).to redirect_to admin_prices_path }
  end

  describe 'POST #batch_action' do
    let(:prices) { [create(:price), create(:price)] }
    before { prices }
    it('deletes the prices') do
      expect do
        post :batch_action,
          batch_action: 'destroy',
          collection_selection_toggle_all: 'on',
          collection_selection: prices
      end.to change(Price, :count).by(-2)
    end
    it('redirects to prices#index') do
      post :batch_action,
        batch_action: 'destroy',
        collection_selection_toggle_all: 'on',
        collection_selection: prices
      expect(response).to redirect_to admin_prices_path
    end
  end
end
