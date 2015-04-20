class OffersController < InheritedResources::Base
  respond_to :html, :json, :xml

  def index
    @offers = Offer.where(
      '(start IS NULL OR start <= NOW()) AND (finish IS NULL OR finish >= NOW())'
    ).order(:finish, :name)
  end

end
