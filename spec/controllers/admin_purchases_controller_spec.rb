require 'rails_helper'

RSpec.describe Admin::PurchasesController, type: :controller do
  let(:admin_user) { create(:admin_user, confirmed_at: Time.zone.now) }
  before { sign_in admin_user }
  let(:purchase) { create(:purchase) }

  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns @purchases' do
      get :index
      expect(assigns(:purchases)).to eq [purchase]
    end
    it('renders the index template') { expect(get :index).to render_template('index') }
  end

  describe 'GET #show' do
    it('responds successfully') { expect(get :show, id: purchase).to be_success }
    it 'assigns the requested purchase to @purchase' do
      get :show, id: purchase
      expect(assigns(:purchase)).to eq purchase
    end
    it('renders the show template') { expect(get :show, id: purchase).to render_template('show') }
  end

  describe 'PATCH #complete' do
    let(:purchase_params) { { completed_at: Time.zone.now, receipt: 'test' } }
    it 'reports an error when already complete' do
      purchase.update! purchase_params
      patch :complete, id: purchase, purchase: purchase_params
      expect(flash).to include [ 'error', 'Purchase already complete' ]
    end

    it 'reports an error on duplicate receipt' do
      create :purchase, purchase_params
      patch :complete, id: purchase, purchase: purchase_params
      expect(flash).to include [ 'error', 'Validation failed: Receipt has already been taken' ]
    end

    it 'processes a purchase' do
      patch :complete, id: purchase, purchase: purchase_params
      purchase.reload
      expect(purchase.receipt).to eq 'test'
    end

    context 'when there are subscriptions' do
      let(:publication) { create :publication }
      let(:offer) { create :offer }
      let(:offer_publication) { create :offer_publication, offer: offer, publication: publication }
      let(:expiry) { Time.zone.tomorrow + rand(365) }
      let(:subscription) { create :subscription, publication: publication, expiry: expiry }
      let(:payment) { create :payment, purchase: purchase, subscription: subscription }
      before do
        offer_publication
        payment
        purchase.update! offer: offer
      end

      it 'extends expiry date' do
        patch :complete, id: purchase, purchase: purchase_params
        subscription.reload
        expect(subscription.expiry).to eq offer_publication.extend_date(expiry)
      end

      context 'when there is a trial period' do
        before do
          offer.update! trial_period: 7
          subscription.update! subscribed: Time.zone.today
          subscription.update! expiry: Time.zone.today + 7.days
        end

        it 'extends expiry date from subscribed date' do
          patch :complete, id: purchase, purchase: purchase_params
          subscription.reload
          expect(subscription.expiry).to eq offer_publication.extend_date(Time.zone.today)
        end
      end
    end
  end
end
