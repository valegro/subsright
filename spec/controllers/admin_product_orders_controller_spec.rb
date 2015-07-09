require 'rails_helper'

RSpec.describe Admin::ProductOrdersController, type: :controller do
  let(:admin_user) { create(:admin_user, confirmed_at: Time.zone.now) }
  before { sign_in admin_user }
  let(:product_order) { create(:product_order) }
  let(:invalid_attributes) { attributes_for(:product_order, customer: nil) }

  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns @product_orders' do
      get :index
      expect(assigns(:product_orders)).to eq [product_order]
    end
    it('renders the index template') { expect(get :index).to render_template('index') }
  end

  describe 'GET #show' do
    it('responds successfully') { expect(get :show, id: product_order).to be_success }
    it 'assigns the requested product_order to @product_order' do
      get :show, id: product_order
      expect(assigns(:product_order)).to eq product_order
    end
    it('renders the show template') { expect(get :show, id: product_order).to render_template('show') }
  end

  describe 'PATCH #shipped' do
    before { product_order }
    it 'locates the requested product_order' do
      patch :shipped, id: product_order
      expect(assigns(:product_order)).to eq product_order
    end
    it "changes the product_order's attributes" do
      patch :shipped, id: product_order
      product_order.reload
      expect(product_order.shipped).to eq Time.zone.today
    end
    it 'redirects to the updated product_order' do
      patch :shipped, id: product_order
      expect(response).to redirect_to admin_product_orders_path
    end
    it 'reports an error if already shipped' do
      product_order.shipped = Time.zone.today
      product_order.save!
      patch :shipped, id: product_order
      expect(flash).to include [ 'error', "Already shipped on #{I18n.l product_order.shipped, format: :long}" ]
    end
  end

  describe 'PATCH #reship' do
    before do
      product_order.shipped = Time.zone.today
      product_order.save!
    end
    it 'locates the requested product_order' do
      patch :reship, id: product_order, product_order: attributes_for(:product_order)
      expect(assigns(:product_order)).to eq product_order
    end
    it "changes the product_order's attributes" do
      patch :reship, id: product_order
      product_order.reload
      expect(product_order.shipped).to eq nil
    end
    it 'redirects to the updated product_order' do
      patch :reship, id: product_order, product_order: attributes_for(:product_order)
      expect(response).to redirect_to admin_product_orders_path
    end
  end

  describe 'POST #batch_action shipped' do
    let(:product_orders) { [ create(:product_order), create(:product_order) ] }
    before { product_orders }
    it 'sets the product_orders shipped dates' do
      post :batch_action,
        batch_action: :shipped,
        collection_selection_toggle_all: 'on',
        collection_selection: product_orders
      ProductOrder.all { |po| expect(po.shipped).to eq Time.zone.today }
    end
    it 'redirects to product_orders#index' do
      post :batch_action,
        batch_action: :shipped,
        collection_selection_toggle_all: 'on',
        collection_selection: product_orders
      expect(response).to redirect_to admin_product_orders_path
    end
  end

  describe 'POST #batch_action reship' do
    let :product_orders do
      [ create(:product_order, shipped: Time.zone.today), create(:product_order, shipped: Time.zone.today) ]
    end
    before { product_orders }
    it 'resets the product_orders shipped dates' do
      post :batch_action,
        batch_action: :reship,
        collection_selection_toggle_all: 'on',
        collection_selection: product_orders
      ProductOrder.all { |po| expect(po.shipped).to eq nil }
    end
    it 'redirects to product_orders#index' do
      post :batch_action,
        batch_action: :reship,
        collection_selection_toggle_all: 'on',
        collection_selection: product_orders
      expect(response).to redirect_to admin_product_orders_path
    end
  end
end
