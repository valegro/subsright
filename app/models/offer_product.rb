class OfferProduct < ActiveRecord::Base
  belongs_to :offer
  accepts_nested_attributes_for :offer
  belongs_to :product
  accepts_nested_attributes_for :product
  validates_presence_of :product
  scope :by_name, lambda { joins(:product).order('products.name') }
end