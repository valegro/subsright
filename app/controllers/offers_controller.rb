class OffersController < InheritedResources::Base
  respond_to :html, :json, :xml

  def index
    @offers = Offer.where('expires IS NULL OR expires >= NOW()').order(:expires, :name)
  end

end
