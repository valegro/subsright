require 'rails_helper'
include Devise::TestHelpers

RSpec.describe Admin::DiscountsController, type: :controller do
  before { sign_in AdminUser.first }
  let(:discount) { create(:discount) }
  let(:invalid_attributes) { attributes_for(:discount, name: nil) }

  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns @discounts' do
      get :index
      expect(assigns(:discounts)).to eq [discount]
    end
    it('renders the index template') { expect(get :index).to render_template('index') }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new discount' do
        expect { post :create, discount: attributes_for(:discount) }.to change(Discount, :count).by(1)
      end
      it 'redirects to the new discount' do
        post :create, discount: attributes_for(:discount)
        expect(response).to redirect_to admin_discount_path(Discount.last)
      end
    end
    context 'with invalid attributes' do
      it 'does not save the new discount' do
        expect { post :create, discount: invalid_attributes }.not_to change(Discount, :count)
      end
      it('re-renders the new template') do
        expect(post :create, discount: invalid_attributes).to render_template('new')
      end
    end
  end

  describe 'GET #new' do
    it('responds successfully') { expect(get :new).to be_success }
    it('renders the new template') { expect(get :new).to render_template('new') }
  end

  describe 'GET #edit' do
    it('responds successfully') { expect(get :edit, id: discount).to be_success }
    it('renders the edit template') { expect(get :edit, id: discount).to render_template('edit') }
  end

  describe 'GET #show' do
    it('responds successfully') { expect(get :show, id: discount).to be_success }
    it 'assigns the requested discount to @discount' do
      get :show, id: discount
      expect(assigns(:discount)).to eq discount
    end
    it('renders the show template') { expect(get :show, id: discount).to render_template('show') }
  end

  describe 'PATCH #update' do
    before { discount }
    context 'with valid attributes' do
      it 'locates the requested discount' do
        patch :update, id: discount, discount: attributes_for(:discount)
        expect(assigns(:discount)).to eq discount
      end
      it "changes the discount's attributes" do
        new_attributes = attributes_for(:discount)
        patch :update, id: discount, discount: new_attributes
        discount.reload
        expect(discount.name).to eq new_attributes[:name]
      end
      it 'redirects to the updated discount' do
        patch :update, id: discount, discount: attributes_for(:discount)
        expect(response).to redirect_to admin_discount_path(discount)
      end
    end
    context 'with invalid attributes' do
      it 'locates the requested discount' do
        patch :update, id: discount, discount: invalid_attributes
        expect(assigns(:discount)).to eq discount
      end
      it "does not change the discount's attributes" do
        name = discount.name
        patch :update, id: discount, discount: invalid_attributes
        discount.reload
        expect(discount.name).to eq name
      end
      it 're-renders the edit template' do
        expect(patch :update, id: discount, discount: invalid_attributes).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    before { discount }
    it('deletes the discount') { expect { delete :destroy, id: discount }.to change(Discount, :count).by(-1) }
    it('redirects to discounts#index') { expect(delete :destroy, id: discount).to redirect_to admin_discounts_path }
  end

  describe 'POST #batch_action' do
    let(:discounts) { [create(:discount), create(:discount)] }
    before { discounts }
    it('deletes the discounts') do
      expect do
        post :batch_action,
          batch_action: 'destroy',
          collection_selection_toggle_all: 'on',
          collection_selection: discounts
      end.to change(Discount, :count).by(-2)
    end
    it('redirects to discounts#index') do
      post :batch_action,
        batch_action: 'destroy',
        collection_selection_toggle_all: 'on',
        collection_selection: discounts
      expect(response).to redirect_to admin_discounts_path
    end
  end
end
