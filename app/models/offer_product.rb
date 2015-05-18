class OfferProduct < ActiveRecord::Base
  belongs_to :offer
  accepts_nested_attributes_for :offer
  belongs_to :product
  accepts_nested_attributes_for :product
  validates :product, presence: true
  scope :by_name, -> { joins(:product).order('products.name') }
end
