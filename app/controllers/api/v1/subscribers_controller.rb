class Api::V1::SubscribersController < Api::ApiController
  respond_to :json
  before_action :authenticate

  def index
    @subscribers = Customer.includes(:subscriptions).joins(:subscriptions)
      .merge(Subscription.where publication: @publication)
    respond_with @subscribers.map { |subscriber| subscriber_data subscriber, subscriber.subscriptions.first }
  end

  def show
    subscriber = Customer.find params[:id]
    subscription = subscriber.subscriptions.where(publication: @publication).first
    if subscription
      respond_with subscriber_data subscriber, subscription
    else
      respond_with [errors: ['Not authorised to request this information']], status: :forbidden
    end
  end

  private

  def subscriber_data(subscriber, subscription)
    subscriber.as_json(except: :user_id).merge(subscription.as_json(only: [:subscribed, :expiry]))
  end
end
