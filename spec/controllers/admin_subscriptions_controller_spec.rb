require 'rails_helper'

RSpec.describe Admin::SubscriptionsController, type: :controller do
  let(:admin_user) { create(:admin_user, confirmed_at: Time.zone.now) }
  before { sign_in admin_user }
  let(:subscription) { create(:subscription) }
  let(:invalid_attributes) { attributes_for(:subscription, subscribed: nil) }

  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns @subscriptions' do
      get :index
      expect(assigns(:subscriptions)).to eq [subscription]
    end
    it('renders the index template') { expect(get :index).to render_template('index') }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:attributes) { attributes_for(:subscription, publication_id: create(:publication).id) }
      it 'creates a new subscription' do
        expect { post :create, subscription: attributes }.to change(Subscription, :count).by(1)
      end
      it 'redirects to the new subscription' do
        post :create, subscription: attributes
        expect(response).to redirect_to admin_subscription_path(Subscription.last)
      end
    end
    context 'with invalid attributes' do
      it 'does not save the new subscription' do
        expect { post :create, subscription: invalid_attributes }.not_to change(Subscription, :count)
      end
      it('re-renders the new template') do
        expect(post :create, subscription: invalid_attributes).to render_template('new')
      end
    end
  end

  describe 'GET #new' do
    it('responds successfully') { expect(get :new).to be_success }
    it('renders the new template') { expect(get :new).to render_template('new') }
  end

  describe 'GET #edit' do
    it('responds successfully') { expect(get :edit, id: subscription).to be_success }
    it('renders the edit template') { expect(get :edit, id: subscription).to render_template('edit') }
  end

  describe 'GET #show' do
    it('responds successfully') { expect(get :show, id: subscription).to be_success }
    it 'assigns the requested subscription to @subscription' do
      get :show, id: subscription
      expect(assigns(:subscription)).to eq subscription
    end
    it('renders the show template') { expect(get :show, id: subscription).to render_template('show') }
  end

  describe 'PATCH #update' do
    before { subscription }
    context 'with valid attributes' do
      it 'locates the requested subscription' do
        patch :update, id: subscription, subscription: attributes_for(:subscription)
        expect(assigns(:subscription)).to eq subscription
      end
      it "changes the subscription's attributes" do
        new_attributes = attributes_for(:subscription)
        patch :update, id: subscription, subscription: new_attributes
        subscription.reload
        expect(subscription.subscribed).to eq new_attributes[:subscribed]
      end
      it 'redirects to the updated subscription' do
        patch :update, id: subscription, subscription: attributes_for(:subscription)
        expect(response).to redirect_to admin_subscription_path(subscription)
      end
    end
    context 'with invalid attributes' do
      it 'locates the requested subscription' do
        patch :update, id: subscription, subscription: invalid_attributes
        expect(assigns(:subscription)).to eq subscription
      end
      it "does not change the subscription's attributes" do
        subscribed = subscription.subscribed
        patch :update, id: subscription, subscription: invalid_attributes
        subscription.reload
        expect(subscription.subscribed).to eq subscribed
      end
      it 're-renders the edit template' do
        expect(patch :update, id: subscription, subscription: invalid_attributes).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    before { subscription }
    it 'deletes the subscription' do
      expect { delete :destroy, id: subscription }.to change(Subscription, :count).by(-1)
    end
    it('redirects to subscriptions#index') do
      expect(delete :destroy, id: subscription).to redirect_to admin_subscriptions_path
    end
  end

  describe 'POST #batch_action' do
    let(:subscriptions) { [create(:subscription), create(:subscription)] }
    before { subscriptions }
    it('deletes the subscriptions') do
      expect do
        post :batch_action,
          batch_action: 'destroy',
          collection_selection_toggle_all: 'on',
          collection_selection: subscriptions
      end.to change(Subscription, :count).by(-2)
    end
    it('redirects to subscriptions#index') do
      post :batch_action,
        batch_action: 'destroy',
        collection_selection_toggle_all: 'on',
        collection_selection: subscriptions
      expect(response).to redirect_to admin_subscriptions_path
    end
  end
end
