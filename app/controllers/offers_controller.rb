class OffersController < InheritedResources::Base
  respond_to :html, :json, :xml

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
    @purchase.customers << Customer.new
  end

  def purchase
    if params[:id].present?
      @purchase = Purchase.make_new(params[:id], purchase_params)
      unless @purchase.save
        flash.alert = @purchase.errors.full_messages.to_sentence
        @offer = Offer.find(params[:id])
        if @offer.prices.present?
          @products = @offer.offer_products.by_name
          @purchase.price_id = purchase_params[:price_id]
          return render :show
        end
      end
    end

    redirect_to action: :index
  end

  private

  def purchase_params
    params.require(:purchase)
      .permit(:price_id, customers_attributes: [:name, :email, :phone, :address, :country, :postcode, :currency])
  end
end
