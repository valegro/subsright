class OfferProduct < ActiveRecord::Base
  belongs_to :offer
  accepts_nested_attributes_for :offer
  belongs_to :product
  accepts_nested_attributes_for :product
  validates :product, presence: true
  scope :by_name, -> { joins(:product).order('products.name') }
  scope :optional_in_stock, -> { joins(:product).where('optional = TRUE AND (stock IS NULL OR stock > 0)') }
end
