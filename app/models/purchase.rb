class Purchase < ActiveRecord::Base
  belongs_to :offer

  has_many :customer_purchases
  has_many :customers, through: :customer_purchases
  accepts_nested_attributes_for :customers

  validates :offer, presence: true

  attr_accessor :price_id

  def currency_name
    m = Money::Currency.new(currency)
    "#{m.name} (#{m.iso_code})"
  end

  def self.make_new(offer_id, params)
    o = Offer.find(offer_id)
    p = Price.find(params[:price_id])
    purchase = Purchase.new(offer: o, price_name: p.name, amount_cents: p.amount_cents, currency: p.currency)
    customers_attributes = params[:customers_attributes]
    purchase.customers.concat customers_attributes.map { |_, c| Customer.new(c) } unless customers_attributes.nil?
    purchase
  end
end
