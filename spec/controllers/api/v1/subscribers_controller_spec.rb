require 'rails_helper'

RSpec.describe Api::V1::SubscribersController, type: :controller do
  before do
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Token.encode_credentials publication.api_key
  end
  let(:publication) { create :publication }
  let(:customer) { create :customer }
  let(:subscription) { create :subscription, publication: publication }
  let(:customer_subscription) { create :customer_subscription, customer: customer, subscription: subscription }

  describe 'GET #index' do
    before do
      customer_subscription
      get :index, format: :json
    end
    it('responds successfully') { expect(response).to be_success }
    it('assigns @publication') { expect(assigns :publication).to eq publication }
    it 'returns subscriber information' do
      body = JSON.parse response.body
      expect(body[0]).to include 'name' => customer.name
      expect(body[0]).to include 'subscribed' => I18n.l(subscription.subscribed)
    end
  end

  describe 'GET #show' do
    before { customer_subscription }
    it('responds successfully') { expect(get :show, id: customer, format: :json).to be_success }
    it 'returns customer information' do
      get :show, id: customer, format: :json
      body = JSON.parse response.body
      expect(body).to include 'name' => customer.name
      expect(body).to include 'subscribed' => I18n.l(subscription.subscribed)
    end
    it('forbids customers of other publications') do
      new_customer = create :customer
      expect(get :show, id: new_customer, format: :json).to be_forbidden
    end
  end
end
