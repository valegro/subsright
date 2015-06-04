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
    redirect_to action: :index unless @offer.prices.count > 0
    @included_products = @offer.offer_products.where('optional = FALSE')
    @optional_products = @offer.offer_products.where('optional = TRUE')
    @customer = Customer.new
  end
end
