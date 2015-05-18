class Discount < ActiveRecord::Base
  has_many :discount_prices
  has_many :prices, through: :discount_prices
  accepts_nested_attributes_for :prices
  validates :name, presence: true, uniqueness: true
end
