class Offer < ActiveRecord::Base
  has_and_belongs_to_many :campaigns
  accepts_nested_attributes_for :campaigns

  has_many :products, through: :offer_products
  accepts_nested_attributes_for :products
  has_many :offer_products
  accepts_nested_attributes_for :offer_products, allow_destroy: true

  has_many :publications, through: :offer_publications
  accepts_nested_attributes_for :publications
  has_many :offer_publications
  accepts_nested_attributes_for :offer_publications, allow_destroy: true

  has_and_belongs_to_many :prices
  accepts_nested_attributes_for :prices

  validates_presence_of :name
end
