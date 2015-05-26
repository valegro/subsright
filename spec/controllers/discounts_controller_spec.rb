require 'rails_helper'

RSpec.describe DiscountsController, type: :controller do
  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns requestable @discounts' do
      create(:discount)
      discount = create(:discount, requestable: true)
      get :index
      expect(assigns(:discounts)).to eq [discount]
    end
    it('renders the index template') { expect(get :index).to render_template('index') }
  end
end
