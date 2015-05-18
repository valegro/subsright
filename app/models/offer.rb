class Offer < ActiveRecord::Base
  has_many :campaign_offers
  has_many :campaigns, through: :campaign_offers
  accepts_nested_attributes_for :campaigns

  has_many :offer_products
  accepts_nested_attributes_for :offer_products, allow_destroy: true
  has_many :products, through: :offer_products
  accepts_nested_attributes_for :products

  has_many :offer_publications
  accepts_nested_attributes_for :offer_publications, allow_destroy: true
  has_many :publications, through: :offer_publications
  accepts_nested_attributes_for :publications

  has_many :offer_prices
  has_many :prices, through: :offer_prices
  accepts_nested_attributes_for :prices

  validates :name, presence: true
  validates :trial_period, numericality: { allow_nil: true, only_integer: true, greater_than: 0 }
end
