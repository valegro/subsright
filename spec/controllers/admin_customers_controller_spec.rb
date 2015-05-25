require 'rails_helper'
include Devise::TestHelpers

RSpec.describe Admin::CustomersController, type: :controller do
  before { sign_in AdminUser.first }
  let(:customer) { create(:customer) }

  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns @customers' do
      get :index
      expect(assigns(:customers)).to eq [customer]
    end
    it('renders the index template') { expect(get :index).to render_template('index') }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new customer' do
        expect { post :create, customer: attributes_for(:customer) }.to change(Customer, :count).by(1)
      end
      it 'redirects to the new customer' do
        post :create, customer: attributes_for(:customer)
        expect(response).to redirect_to admin_customer_path(Customer.last)
      end
    end
    context 'with invalid attributes' do
      it 'does not save the new customer' do
        expect { post :create, customer: nil }.not_to change(Customer, :count)
      end
      it('re-renders the new method') { expect(post :create, customer: nil).to render_template('new') }
    end
  end

  describe 'GET #new' do
    it('responds successfully') { expect(get :new).to be_success }
    it('renders the new template') { expect(get :new).to render_template('new') }
  end

  describe 'GET #edit' do
    it('responds successfully') { expect(get :edit, id: customer).to be_success }
    it('renders the edit template') { expect(get :edit, id: customer).to render_template('edit') }
  end

  describe 'GET #show' do
    it('responds successfully') { expect(get :show, id: customer).to be_success }
    it 'assigns the requested customer to @customer' do
      get :show, id: customer
      expect(assigns(:customer)).to eq customer
    end
    it('renders the show template') { expect(get :show, id: customer).to render_template('show') }
  end

  describe 'PATCH #update' do
    before { customer }
    context 'with valid attributes' do
      it 'locates the requested customer' do
        patch :update, id: customer, customer: attributes_for(:customer)
        expect(assigns(:customer)).to eq customer
      end
      it "changes the customer's attributes" do
        new_attributes = attributes_for(:customer)
        patch :update, id: customer, customer: new_attributes
        customer.reload
        expect(customer.name).to eq new_attributes[:name]
      end
      it 'redirects to the updated customer' do
        patch :update, id: customer, customer: attributes_for(:customer)
        expect(response).to redirect_to admin_customer_path(customer)
      end
    end
    context 'with invalid attributes' do
      it 'locates the requested customer' do
        patch :update, id: customer, customer: nil
        expect(assigns(:customer)).to eq customer
      end
      it "does not change the customer's attributes" do
        name = customer.name
        patch :update, id: customer, customer: nil
        customer.reload
        expect(customer.name).to eq name
      end
      it 'redirects back to the customer' do
        patch :update, id: customer, customer: nil
        expect(response).to redirect_to admin_customer_path(customer)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { customer }
    it('deletes the customer') { expect { delete :destroy, id: customer }.to change(Customer, :count).by(-1) }
    it('redirects to customers#index') { expect(delete :destroy, id: customer).to redirect_to admin_customers_path }
  end

  describe 'POST #batch_action' do
    let(:customers) { [create(:customer), create(:customer)] }
    before { customers }
    it('deletes the customers') do
      expect do
        post :batch_action,
          batch_action: 'destroy',
          collection_selection_toggle_all: 'on',
          collection_selection: customers
      end.to change(Customer, :count).by(-2)
    end
    it('redirects to customers#index') do
      post :batch_action,
        batch_action: 'destroy',
        collection_selection_toggle_all: 'on',
        collection_selection: customers
      expect(response).to redirect_to admin_customers_path
    end
  end
end
