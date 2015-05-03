class CustomerDiscount < ActiveRecord::Base
  belongs_to :customer
  accepts_nested_attributes_for :customer
  belongs_to :discount
  accepts_nested_attributes_for :discount
  validates_presence_of :discount
  scope :by_name, lambda { joins(:discount).order('discounts.name') }
end
