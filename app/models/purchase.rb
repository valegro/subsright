class Purchase < ActiveRecord::Base
  belongs_to :offer

  has_many :renewals
  has_many :subscriptions, through: :renewals
  has_many :product_orders
  has_many :products, through: :product_orders
  has_many :transactions

  attr_accessor :timestamp

  validates :offer, presence: true
  validates :token, uniqueness: { allow_blank: true }

  def amount
    Money.new( amount_cents, currency ).format
  end

  def currency_name
    m = Money::Currency.new(currency)
    "#{m.name} (#{m.iso_code})"
  end

  def initial_amount
    Money.new(initial_amount_cents, currency).format if initial_amount_cents
  end

  def initial_amount=(initial_amount)
    initial_amount.tr!('^0-9', '')
    self.initial_amount_cents = initial_amount.to_i > 0 ? initial_amount : nil
  end

  def to_s
    if cancelled_at
      status = ( payment_due ? 'cancelled' : 'reversed' ) + ' at ' + I18n.l(cancelled_at, format: :long)
    elsif payment_due
      status = 'payment due ' + I18n.l(payment_due, format: :long)
    else
      status = 'completed'
    end

    "#{currency} #{amount} (#{status})"
  end

  def total_cents
    (initial_amount_cents || 0) + amount_cents * (monthly_payments ? monthly_payments : 1)
  end
end
