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
    @purchase = Purchase.new(offer: @offer)
    @customer = Customer.new(price_id: @offer.prices.first.id)
    first_op = @offer.offer_products.optional_in_stock.order('products.stock DESC').first
    @customer.product_id = first_op.product_id if first_op
  end

  def purchase
    if params[:id].present?
      purchase_offer!(params[:id])
      flash.alert = nil
      flash.notice = 'Transaction complete.  Thank you!'
    end

    redirect_to action: :index
  end

  protected

  def show_errors(exception)
    return redirect_to action: :index if @offer.prices.empty?

    flash.alert = exception.message
    @products = @offer.offer_products.by_name
    @customer = Customer.new(customer_params)
    render :show
  end

  private

  def customer_params
    purchase_params.require(:customer)
      .permit(:name, :email, :phone, :address, :country, :postcode, :price_id, :product_id)
  end

  def purchase_offer!(id)
    @offer = Offer.find(id)
    @purchase = Purchase.new(offer: @offer)
    if customer_params
      update_or_create_customer!
      price = Price.find(customer_params[:price_id])
      @purchase.amount_cents = price.amount_cents
      @purchase.currency = price.currency
      purchase_publications!(price.name)
      purchase_products!
    end
    @purchase.save!
  end

  def purchase_params
    params.require(:purchase)
  end

  def purchase_products!
    @offer.offer_products.where(optional: false).each do |offer_product|
      ProductOrder.new(customer: @customer, purchase: @purchase, product: offer_product.product).save!
    end
    return unless customer_params[:product_id]
    product = Product.find(customer_params[:product_id])
    ProductOrder.new(customer: @customer, purchase: @purchase, product: product).save! if product
  end

  def purchase_publications!(price_name)
    @offer.offer_publications.each do |op|
      subscription = Subscription.joins(:customer_subscriptions)
        .where(publication: op.publication, customer_subscriptions: { customer: @customer }).first
      unless subscription
        subscription = Subscription.new(
          publication: op.publication,
          user: current_user,
          subscribers: op.subscribers,
          subscribed: Time.zone.today
        )
        subscription.expiry = Time.zone.today + @offer.trial_period if @offer.trial_period
      end
      subscription.save!
      CustomerSubscription.find_or_create_by(customer: @customer, subscription: subscription).save!
      Payment.new(purchase: @purchase, subscription: subscription, price_name: price_name).save!
    end
  end

  def update_or_create_customer!
    email = customer_params[:email]
    @customer = email.present? && Customer.find_by(email: email, name: customer_params[:name])
    if @customer
      @customer.update!(customer_params)
    else
      @customer = Customer.new(customer_params)
      if email.present?
        user = User.find_by(email: email) || User.new(name: customer_params[:name], email: email)
        user.save!
        @customer.user = user
      end
      @customer.save!
    end
  end
end
