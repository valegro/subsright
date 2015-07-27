require 'rails_helper'

RSpec.describe ConfirmationsController, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'GET #show' do
    it('responds successfully') { expect(get :show).to be_success }
    it 'assigns the original token to @original_token' do
      get :show, confirmation_token: 'test'
      expect(assigns(:original_token)).to eq 'test'
    end
    it 'assigns the original user token to @original_token' do
      get :show, user: { confirmation_token: 'test' }
      expect(assigns(:original_token)).to eq 'test'
    end
    context 'when the token does not exist' do
      it('renders the new template') { expect(get :show).to render_template :new }
    end
    context 'when the user is already confirmed' do
      before { create(:user, confirmation_token: 'test', confirmed_at: Time.zone.now) }
      it('renders the new template') { expect(get :show, confirmation_token: 'test').to render_template :new }
    end
    context 'when the token is valid' do
      let(:user) { create :user }
      before { user.update! confirmation_token: Devise.token_generator.digest(self, :confirmation_token, 'test') }
      it('renders the show template') { expect(get :show, confirmation_token: 'test').to render_template :show }
    end
  end

  describe 'PATCH #confirm' do
    context 'when the token does not exist' do
      it('redirects to new') { expect(patch :confirm).to redirect_to :new_user_confirmation }
    end
    context 'when a password is not provided' do
      let(:user) { create :user }
      before { user.update! confirmation_token: Devise.token_generator.digest(self, :confirmation_token, 'test') }
      it 'renders the show template' do
        expect(patch :confirm, user: { confirmation_token: 'test' }).to render_template :show
      end
    end
    context 'when a new password is provided' do
      let(:params) { { confirmation_token: 'test', password: 'password', password_confirmation: 'password' } }
      let(:user) { create :user }
      before { user.update! confirmation_token: Devise.token_generator.digest(self, :confirmation_token, 'test') }
      it 'signs in and redirects to the home page' do
        expect(patch :confirm, user: params).to redirect_to :root
        expect(subject.current_user).to eq user
      end
    end
  end
end
