require 'rails_helper'
include Devise::TestHelpers

RSpec.describe Admin::AdminUsersController, type: :controller do
  let(:admin_user) { create(:admin_user) }
  let(:invalid_attributes) { attributes_for(:admin_user, name: nil) }
  before { sign_in AdminUser.first }

  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns @admin_users' do
      get :index
      expect(assigns(:admin_users)).to eq [AdminUser.first]
    end
    it('renders the index template') { expect(get :index).to render_template('index') }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new admin_user' do
        expect { post :create, admin_user: attributes_for(:admin_user) }.to change(AdminUser, :count).by(1)
      end
      it 'redirects to the new admin_user' do
        post :create, admin_user: attributes_for(:admin_user)
        expect(response).to redirect_to admin_admin_user_path(AdminUser.last)
      end
    end
    context 'with invalid attributes' do
      it 'does not save the new admin_user' do
        expect { post :create, admin_user: invalid_attributes }.not_to change(AdminUser, :count)
      end
      it 're-renders the new template' do
        expect(post :create, admin_user: invalid_attributes).to render_template('new')
      end
    end
  end

  describe 'GET #new' do
    it('responds successfully') { expect(get :new).to be_success }
    it('renders the new template') { expect(get :new).to render_template('new') }
  end

  describe 'GET #edit' do
    it('responds successfully') { expect(get :edit, id: admin_user).to be_success }
    it('renders the edit template') { expect(get :edit, id: admin_user).to render_template('edit') }
  end

  describe 'GET #show' do
    it('responds successfully') { expect(get :show, id: admin_user).to be_success }
    it 'assigns the requested admin_user to @admin_user' do
      get :show, id: admin_user
      expect(assigns(:admin_user)).to eq admin_user
    end
    it('renders the show template') { expect(get :show, id: admin_user).to render_template('show') }
  end

  describe 'PATCH #update' do
    before { admin_user }
    context 'with valid attributes' do
      it 'locates the requested admin_user' do
        patch :update, id: admin_user, admin_user: attributes_for(:admin_user)
        expect(assigns(:admin_user)).to eq admin_user
      end
      it "changes the admin_user's attributes" do
        new_attributes = attributes_for(:admin_user)
        patch :update, id: admin_user, admin_user: new_attributes
        admin_user.reload
        expect(admin_user.name).to eq new_attributes[:name]
      end
      it 'redirects to the updated admin_user' do
        patch :update, id: admin_user, admin_user: attributes_for(:admin_user)
        expect(response).to redirect_to admin_admin_user_path(admin_user)
      end
    end
    context 'with invalid attributes' do
      it 'locates the requested admin_user' do
        patch :update, id: admin_user, admin_user: invalid_attributes
        expect(assigns(:admin_user)).to eq admin_user
      end
      it "does not change the admin_user's attributes" do
        name = admin_user.name
        patch :update, id: admin_user, admin_user: invalid_attributes
        admin_user.reload
        expect(admin_user.name).to eq name
      end
      it 're-renders the edit template' do
        expect(patch :update, id: admin_user, admin_user: invalid_attributes).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    before { admin_user }
    it('deletes the admin_user') { expect { delete :destroy, id: admin_user }.to change(AdminUser, :count).by(-1) }
    it('redirects to admin_users#index') do
      expect(delete :destroy, id: admin_user).to redirect_to admin_admin_users_path
    end
  end

  describe 'POST #batch_action' do
    let(:admin_users) { [create(:admin_user), create(:admin_user)] }
    before { admin_users }
    it('deletes the admin_users') do
      expect do
        post :batch_action,
          batch_action: 'destroy',
          collection_selection_toggle_all: 'on',
          collection_selection: admin_users
      end.to change(AdminUser, :count).by(-2)
    end
    it('redirects to admin_users#index') do
      post :batch_action,
        batch_action: 'destroy',
        collection_selection_toggle_all: 'on',
        collection_selection: admin_users
      expect(response).to redirect_to admin_admin_users_path
    end
  end
end
