class Purchase < ActiveRecord::Base
  belongs_to :offer

  has_many :payments
  has_many :subscriptions, through: :payments
  has_many :product_orders
  has_many :products, through: :product_orders

  attr_accessor :timestamp

  validates :offer, presence: true
  validates :receipt, presence: true, uniqueness: { allow_blank: true }, unless: 'completed_at.nil?'

  def amount
    Money.new( amount_cents, currency ).format
  end

  def currency_name
    m = Money::Currency.new(currency)
    "#{m.name} (#{m.iso_code})"
  end

  def to_s
    if cancelled_at
      status = ( completed_at ? 'reversed' : 'cancelled' ) + ' at ' + I18n.l(cancelled_at, format: :long)
    elsif completed_at
      status = 'completed at ' + I18n.l(completed_at, format: :long)
    else
      status = 'pending'
    end

    "#{currency} #{amount} (#{status})"
  end
end
