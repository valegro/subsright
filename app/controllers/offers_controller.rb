class OffersController < InheritedResources::Base
  respond_to :html, :json, :xml

  def index
    @offers = Offer.where('expiry IS NULL OR expiry >= NOW()').order(:expiry, :name)
  end

end
