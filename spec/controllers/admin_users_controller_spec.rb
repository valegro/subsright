require 'rails_helper'
include Devise::TestHelpers

RSpec.describe Admin::UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:invalid_attributes) { attributes_for(:user, name: nil) }
  before { sign_in AdminUser.first }

  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns @users' do
      get :index
      expect(assigns(:users)).to eq [user]
    end
    it('renders the index template') { expect(get :index).to render_template('index') }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new user' do
        expect { post :create, user: attributes_for(:user) }.to change(User, :count).by(1)
      end
      it 'redirects to the new user' do
        post :create, user: attributes_for(:user)
        expect(response).to redirect_to admin_user_path(User.last)
      end
    end
    context 'with invalid attributes' do
      it 'does not save the new user' do
        expect { post :create, user: invalid_attributes }.not_to change(User, :count)
      end
      it 're-renders the new template' do
        expect(post :create, user: invalid_attributes).to render_template('new')
      end
    end
  end

  describe 'GET #new' do
    it('responds successfully') { expect(get :new).to be_success }
    it('renders the new template') { expect(get :new).to render_template('new') }
  end

  describe 'GET #edit' do
    it('responds successfully') { expect(get :edit, id: user).to be_success }
    it('renders the edit template') { expect(get :edit, id: user).to render_template('edit') }
  end

  describe 'GET #show' do
    it('responds successfully') { expect(get :show, id: user).to be_success }
    it 'assigns the requested user to @user' do
      get :show, id: user
      expect(assigns(:user)).to eq user
    end
    it('renders the show template') { expect(get :show, id: user).to render_template('show') }
  end

  describe 'PATCH #update' do
    before { user }
    context 'with valid attributes' do
      it 'locates the requested user' do
        patch :update, id: user, user: attributes_for(:user)
        expect(assigns(:user)).to eq user
      end
      it "changes the user's attributes" do
        new_attributes = attributes_for(:user)
        patch :update, id: user, user: new_attributes
        user.reload
        expect(user.name).to eq new_attributes[:name]
      end
      it 'redirects to the updated user' do
        patch :update, id: user, user: attributes_for(:user)
        expect(response).to redirect_to admin_user_path(user)
      end
    end
    context 'with invalid attributes' do
      it 'locates the requested user' do
        patch :update, id: user, user: invalid_attributes
        expect(assigns(:user)).to eq user
      end
      it "does not change the user's attributes" do
        name = user.name
        patch :update, id: user, user: invalid_attributes
        user.reload
        expect(user.name).to eq name
      end
      it 're-renders the edit template' do
        expect(patch :update, id: user, user: invalid_attributes).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    before { user }
    it('deletes the user') { expect { delete :destroy, id: user }.to change(User, :count).by(-1) }
    it('redirects to users#index') do
      expect(delete :destroy, id: user).to redirect_to admin_users_path
    end
  end

  describe 'POST #batch_action' do
    let(:users) { [create(:user), create(:user)] }
    before { users }
    it('deletes the users') do
      expect do
        post :batch_action,
          batch_action: 'destroy',
          collection_selection_toggle_all: 'on',
          collection_selection: users
      end.to change(User, :count).by(-2)
    end
    it('redirects to users#index') do
      post :batch_action,
        batch_action: 'destroy',
        collection_selection_toggle_all: 'on',
        collection_selection: users
      expect(response).to redirect_to admin_users_path
    end
  end
end
