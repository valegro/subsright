class Purchase < ActiveRecord::Base
  belongs_to :offer

  has_many :payments
  has_many :subscriptions, through: :payments
  has_many :customers, through: :subscriptions

  validates :offer, presence: true

  attr_accessor :price_id

  def currency_name
    m = Money::Currency.new(currency)
    "#{m.name} (#{m.iso_code})"
  end
end
