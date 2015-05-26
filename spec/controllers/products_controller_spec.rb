require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns @products in descending order of stock' do
      product1 = create(:product, stock: 1)
      product2 = create(:product, stock: 2)
      get :index
      expect(assigns(:products)).to eq [product2, product1]
    end
    it('renders the index template') { expect(get :index).to render_template('index') }
  end

  describe 'GET #show' do
    let(:product) { create(:product) }
    it('responds successfully') { expect(get :show, id: product).to be_success }
    it 'assigns the requested product to @product' do
      get :show, id: product
      expect(assigns(:product)).to eq product
    end
    it('renders the show template') { expect(get :show, id: product).to render_template('show') }
  end
end
