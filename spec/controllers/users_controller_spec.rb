require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  context 'when not signed in' do
    it 'redirects to sign in page' do
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, scope: :user)
      get :show
      expect(response).to redirect_to new_user_session_path
    end
  end

  context 'when signed in' do
    let(:user) { create(:user, confirmed_at: Time.zone.now) }
    let(:invalid_attributes) { attributes_for(:user, name: nil) }
    before { sign_in user }

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
          expect(response).to redirect_to profile_path
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
  end
end
