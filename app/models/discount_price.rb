class DiscountPrice < ActiveRecord::Base
  belongs_to :discount
  belongs_to :price
end
