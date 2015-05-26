require 'rails_helper'

RSpec.describe PricesController, type: :controller do
  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns @prices' do
      price = create(:price)
      get :index
      expect(assigns(:prices)).to eq [price]
    end
    it('renders the index template') { expect(get :index).to render_template('index') }
  end
end
