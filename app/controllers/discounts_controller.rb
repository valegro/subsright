class DiscountsController < InheritedResources::Base
  respond_to :html, :json, :xml

  def index
    @discounts = Discount.where('requestable = TRUE').order(:name)
  end

end
