require 'rails_helper'

RSpec.describe Admin::ProductsController, type: :controller do
  let(:admin_user) { create :admin_user, confirmed_at: Time.zone.now }
  before { sign_in admin_user }
  let(:product) { create :product }
  let(:invalid_attributes) { attributes_for :product, name: nil }

  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns @products' do
      get :index
      expect(assigns :products).to eq [product]
    end
    it('renders the index template') { expect(get :index).to render_template :index }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new product' do
        expect { post :create, product: attributes_for(:product) }.to change(Product, :count).by(1)
      end
      it 'redirects to the new product' do
        post :create, product: attributes_for(:product)
        expect(response).to redirect_to admin_product_path(Product.last)
      end
    end
    context 'with invalid attributes' do
      it 'does not save the new product' do
        expect { post :create, product: invalid_attributes }.not_to change(Product, :count)
      end
      it('re-renders the new template') { expect(post :create, product: invalid_attributes).to render_template :new }
    end
  end

  describe 'GET #new' do
    it('responds successfully') { expect(get :new).to be_success }
    it('renders the new template') { expect(get :new).to render_template :new }
  end

  describe 'GET #edit' do
    it('responds successfully') { expect(get :edit, id: product).to be_success }
    it('renders the edit template') { expect(get :edit, id: product).to render_template :edit }
  end

  describe 'GET #show' do
    it('responds successfully') { expect(get :show, id: product).to be_success }
    it 'assigns the requested product to @product' do
      get :show, id: product
      expect(assigns :product).to eq product
    end
    it('renders the show template') { expect(get :show, id: product).to render_template :show }
  end

  describe 'PATCH #update' do
    before { product }
    context 'with valid attributes' do
      it 'locates the requested product' do
        patch :update, id: product, product: attributes_for(:product)
        expect(assigns :product).to eq product
      end
      it "changes the product's attributes" do
        new_attributes = attributes_for :product
        patch :update, id: product, product: new_attributes
        product.reload
        expect(product.name).to eq new_attributes[:name]
      end
      it 'redirects to the updated product' do
        patch :update, id: product, product: attributes_for(:product)
        expect(response).to redirect_to admin_product_path(product)
      end
    end
    context 'with invalid attributes' do
      it 'locates the requested product' do
        patch :update, id: product, product: invalid_attributes
        expect(assigns :product).to eq product
      end
      it "does not change the product's attributes" do
        name = product.name
        patch :update, id: product, product: invalid_attributes
        product.reload
        expect(product.name).to eq name
      end
      it 're-renders the edit template' do
        expect(patch :update, id: product, product: invalid_attributes).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { product }
    it('deletes the product') { expect { delete :destroy, id: product }.to change(Product, :count).by(-1) }
    it('redirects to products#index') { expect(delete :destroy, id: product).to redirect_to admin_products_path }
  end

  describe 'POST #batch_action' do
    let(:products) { [create(:product), create(:product)] }
    before { products }
    it 'deletes the products' do
      expect do
        post :batch_action,
          batch_action: :destroy,
          collection_selection_toggle_all: 'on',
          collection_selection: products
      end.to change(Product, :count).by(-2)
    end
    it 'redirects to products#index' do
      post :batch_action,
        batch_action: :destroy,
        collection_selection_toggle_all: 'on',
        collection_selection: products
      expect(response).to redirect_to admin_products_path
    end
  end
end
