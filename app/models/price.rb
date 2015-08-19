class Price < ActiveRecord::Base
  has_many :offer_prices
  has_many :offers, through: :offer_prices
  accepts_nested_attributes_for :offers

  has_many :discount_prices
  has_many :discounts, through: :discount_prices
  accepts_nested_attributes_for :discounts

  validates :currency, presence: true
  validates :amount_cents, presence: true
  validates :name, presence: true, uniqueness: { scope: :currency }
  validates :monthly_payments, allow_nil: true, numericality: { only_integer: true, greater_than: 0 }

  def amount
    Money.new(amount_cents, currency).format
  end

  def amount=(amount)
    self.amount_cents = amount.tr('^0-9', '')
  end

  def currency_name
    m = Money::Currency.new(currency)
    "#{m.name} (#{m.iso_code})"
  end

  def description
    desc = ''
    desc += "#{initial_amount} #{currency} now, followed by " if initial_amount_cents
    desc += "#{monthly_payments} monthly payments of " if monthly_payments
    desc += "#{amount} #{currency}"
    desc += ' each' if monthly_payments
    desc += ' (' + discounts.order(:name).map(&:name).join(', ') + ')' if discounts.exists?
    desc
  end

  def initial_amount
    Money.new(initial_amount_cents, currency).format if initial_amount_cents
  end

  def initial_amount=(initial_amount)
    initial_amount.tr!('^0-9', '')
    self.initial_amount_cents = initial_amount.to_i > 0 ? initial_amount : nil
  end

  def to_s
    "#{name}: #{description}"
  end

  def first_payment(trial_period)
    if trial_period || initial_amount_cents
      text = 'on ' +
        I18n.l(Time.zone.today + (trial_period || 0).days + (initial_amount_cents ? 1 : 0).months, format: :long)
    else
      text = 'now'
    end
    monthly_payments ? 'starting ' + text : text
  end
end
