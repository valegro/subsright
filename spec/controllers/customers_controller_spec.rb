require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  attribute_list = [:user_id, :name, :email, :phone, :address, :country, :postcode, :currency]
  let(:customer) { create(:customer) }
  let(:attributes) { attributes_for(:customer, user_id: create(:user)) }
  let(:invalid_attributes) { attributes_for(:customer, name: nil) }

  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns @customers' do
      get :index
      expect(assigns(:customers)).to eq [customer]
    end
    it('renders the index template') { expect(get :index).to render_template('index') }
  end

  describe 'POST #create' do
    it { is_expected.to permit(*attribute_list).for(:create) }
    context 'with valid attributes' do
      it 'creates a new customer' do
        expect { post :create, customer: attributes }.to change(Customer, :count).by(1)
      end
      it 'redirects to the new customer' do
        post :create, customer: attributes
        expect(response).to redirect_to customer_path(Customer.last)
      end
    end
    context 'with invalid attributes' do
      it 'does not save the new customer' do
        expect { post :create, customer: invalid_attributes }.not_to change(Customer, :count)
      end
      it('re-renders the new template') { expect(post :create, customer: invalid_attributes).to render_template('new') }
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
    it { is_expected.to permit(*attribute_list).for(:update, params: { id: customer }) }
    context 'with valid attributes' do
      it 'locates the requested customer' do
        patch :update, id: customer, customer: attributes
        expect(assigns(:customer)).to eq customer
      end
      it "changes the customer's attributes" do
        new_attributes = attributes_for(:customer)
        patch :update, id: customer, customer: new_attributes
        customer.reload
        expect(customer.name).to eq new_attributes[:name]
      end
      it 'redirects to the updated customer' do
        patch :update, id: customer, customer: attributes
        expect(response).to redirect_to customer_path(customer)
      end
    end
    context 'with invalid attributes' do
      it 'locates the requested customer' do
        patch :update, id: customer, customer: invalid_attributes
        expect(assigns(:customer)).to eq customer
      end
      it "does not change the customer's attributes" do
        name = customer.name
        patch :update, id: customer, customer: invalid_attributes
        customer.reload
        expect(customer.name).to eq name
      end
      it 're-renders the edit template' do
        expect(patch :update, id: customer, customer: invalid_attributes).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    before { customer }
    it('deletes the customer') { expect { delete :destroy, id: customer }.to change(Customer, :count).by(-1) }
    it('redirects to customers#index') { expect(delete :destroy, id: customer).to redirect_to customers_path }
  end
end
