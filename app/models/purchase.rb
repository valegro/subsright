class Purchase < ActiveRecord::Base
  belongs_to :offer

  has_many :payments
  has_many :subscriptions, through: :payments
  has_many :product_orders
  has_many :products, through: :product_orders

  validates :offer, presence: true

  def amount
    Money.new( amount_cents, currency ).format
  end

  def currency_name
    m = Money::Currency.new(currency)
    "#{m.name} (#{m.iso_code})"
  end

  def to_s
    "#{currency} #{amount} (" + ( completed_at ? 'completed at ' + I18n.l(completed_at, format: :long) : 'pending' ) +
      ')'
  end
end
