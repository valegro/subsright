class CustomerDiscount < ActiveRecord::Base
  belongs_to :customer
  accepts_nested_attributes_for :customer
  belongs_to :discount
  accepts_nested_attributes_for :discount
  validates :discount, presence: true
  scope :by_name, -> { joins(:discount).order('discounts.name') }
end
