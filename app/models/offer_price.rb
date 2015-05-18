class OfferPrice < ActiveRecord::Base
  belongs_to :offer
  belongs_to :price
end
