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

  describe 'PATCH #update' do
    let(:purchase_params) { { timestamp: Time.zone.now } }
    let(:cancel_params) { { cancelled_at: purchase_params[:timestamp] } }

    it('ignores invalid actions') { expect(patch :update, id: purchase).to redirect_to :admin_purchase }

    context 'when cancelling a purchase' do
      it 'reports an error when already cancelled' do
        purchase.update! cancel_params
        patch :update, commit: 'Cancel purchase', id: purchase, purchase: purchase_params
        expect(flash).to include [ 'error', 'Purchase already cancelled' ]
      end

      it 'cancels a purchase' do
        patch :update, commit: 'Cancel purchase', id: purchase, purchase: purchase_params
        purchase.reload
        expect(purchase.cancelled_at).to be
      end
    end

    context 'when completing a purchase' do
      it 'reports an error when already complete' do
        purchase.update! payment_due: nil
        patch :update, commit: 'Complete purchase', id: purchase, purchase: purchase_params
        expect(flash).to include [ 'error', 'Purchase already complete' ]
      end

      it 'completes a purchase' do
        patch :update, commit: 'Complete purchase', id: purchase, purchase: purchase_params
        purchase.reload
        expect(purchase.payment_due).to be nil
      end
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

      context 'when cancelling a purchase' do
        it 'reduces expiry date' do
          patch :update, commit: 'Cancel purchase', id: purchase, purchase: purchase_params
          subscription.reload
          expect(subscription.expiry).to eq offer_publication.reduce_date(expiry)
        end

        it 'ignores eternal subscriptions' do
          subscription.update! expiry: nil
          expect { patch :update, commit: 'Cancel purchase', id: purchase, purchase: purchase_params }
            .not_to raise_error
        end

        it 'deletes payments' do
          patch :update, commit: 'Cancel purchase', id: purchase, purchase: purchase_params
          expect(Payment.exists? payment.id).to be false
        end

        it 'does not delete completed payments' do
          purchase.update! payment_due: nil
          patch :update, commit: 'Reverse purchase', id: purchase, purchase: purchase_params
          expect(Payment.exists? payment.id).to be true
        end

        it 'deletes unshipped product orders' do
          product_order = create(:product_order, purchase: purchase)
          patch :update, commit: 'Cancel purchase', id: purchase, purchase: purchase_params
          expect(ProductOrder.exists? product_order.id).to be false
        end

        it 'does not delete shipped product orders' do
          product_order = create(:product_order, purchase: purchase, shipped: Time.zone.today)
          patch :update, commit: 'Cancel purchase', id: purchase, purchase: purchase_params
          expect(ProductOrder.exists? product_order.id).to be true
        end
      end

      context 'when completing a purchase' do
        it 'extends expiry date' do
          patch :update, commit: 'Complete purchase', id: purchase, purchase: purchase_params
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
            patch :update, commit: 'Complete purchase', id: purchase, purchase: purchase_params
            subscription.reload
            expect(subscription.expiry).to eq offer_publication.extend_date(Time.zone.today)
          end
        end
      end
    end
  end
end
