class Purchase < ActiveRecord::Base
  belongs_to :offer

  has_many :customer_purchases
  has_many :customers, through: :customer_purchases

  validates :offer, presence: true

  def currency_name
    m = Money::Currency.new(currency)
    "#{m.name} (#{m.iso_code})"
  end
end
