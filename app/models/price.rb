class Price < ActiveRecord::Base
  has_and_belongs_to_many :offers
  accepts_nested_attributes_for :offers
  has_and_belongs_to_many :discounts
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

  def currencies
    Money::Currency.table.map { |m| [ "#{m[1][:name]} (#{m[1][:iso_code]})", m[1][:iso_code] ] }
  end

  def currency_name
    m = Money::Currency.new(currency)
    "#{m.name} (#{m.iso_code})"
  end
end
