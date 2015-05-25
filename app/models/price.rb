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

  def amount
    Money.new( amount_cents, currency ).format
  end

  def amount=(amount)
    self.amount_cents = amount.tr('^0-9', '')
  end

  def self.currencies
    Money::Currency.table.map { |m| [ "#{m[1][:name]} (#{m[1][:iso_code]})", m[1][:iso_code] ] }
  end

  def currency_name
    m = Money::Currency.new(currency)
    "#{m.name} (#{m.iso_code})"
  end
end
