class OffersController < InheritedResources::Base
  respond_to :html, :json, :xml

  def index
    @offers = Offer.where(
      '(start IS NULL OR start <= NOW()) AND (finish IS NULL OR finish >= NOW())'
    ).order(:finish, :name)
  end

  def show
    @offer = Offer.find(params[:id])
    @included_products = @offer.offer_products.where('optional = FALSE')
    @optional_products = @offer.offer_products.where('optional = TRUE')
  end
end
