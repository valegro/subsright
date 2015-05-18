class Campaign < ActiveRecord::Base
  has_many :campaign_offers
  has_many :offers, through: :campaign_offers
  accepts_nested_attributes_for :offers
  validates :name, presence: true
end
