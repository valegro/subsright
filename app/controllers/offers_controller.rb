class OffersController < InheritedResources::Base
  respond_to :html, :json, :xml
  rescue_from ActiveRecord::RecordInvalid, with: :show_errors

  def index
    @offers = Offer.joins(:offer_prices)
      .where('(start IS NULL OR start <= NOW()) AND (finish IS NULL OR finish >= NOW())')
      .group(:id)
      .having('COUNT(price_id) > 0')
      .order(:finish, :name)
  end

  def show
    @offer = Offer.find(params[:id])
    return redirect_to action: :index if @offer.prices.empty?

    @products = @offer.offer_products.by_name
    @purchase = Purchase.new(offer: @offer, price_id: @offer.prices.first.id)
    @customer = Customer.new
  end

  def purchase
    if params[:id].present?
      @offer = Offer.find(params[:id])
      price = Price.find(purchase_params[:price_id])
      @purchase = Purchase.new(offer: @offer, amount_cents: price.amount_cents, currency: price.currency)
      if customer_params
        update_or_create_customer!
        purchase_publications!(price.name)
      end
      @purchase.save!
      flash.alert = nil
      flash.notice = 'Transaction complete.  Thank you!'
    end

    redirect_to action: :index
  end

  protected

  def show_errors(exception)
    if @offer.prices.count == 0
      redirect_to action: :index
    else
      flash.alert = exception.message
      @products = @offer.offer_products.by_name
      @purchase.price_id = purchase_params[:price_id]
      @customer = Customer.new(customer_params)
      render :show
    end
  end

  private

  def customer_params
    purchase_params.require(:customer).permit(:name, :email, :phone, :address, :country, :postcode, :currency)
  end

  def purchase_params
    params.require(:purchase)
      .permit(:price_id, customer: [:name, :email, :phone, :address, :country, :postcode, :currency])
  end

  def purchase_publications!(price_name)
    @offer.offer_publications.each do |offer_publication|
      subscription = Subscription.new(
        customer: @customer,
        publication: offer_publication.publication,
        subscribed: Time.zone.today)
      subscription.save!
      Payment.new(purchase: @purchase, subscription: subscription, price_name: price_name).save!
    end
  end

  def update_or_create_customer!
    @customer = customer_params[:email].present? &&
      Customer.find_by(email: customer_params[:email], name: customer_params[:name])
    if @customer
      @customer.update!(customer_params)
    else
      @customer = Customer.new(customer_params)
      @customer.save!
    end
  end
end
