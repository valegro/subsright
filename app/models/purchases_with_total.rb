class PurchasesWithTotal < ActiveRecord::Base
  after_initialize :readonly!
  belongs_to :purchase
  belongs_to :offer
  self.primary_key = 'id'

  has_many :renewals, through: :purchase
  has_many :subscriptions, through: :renewals
  has_many :product_orders, through: :purchase
  has_many :products, through: :product_orders
  has_many :transactions, through: :purchase

  attr_accessor :receipt, :timestamp, :transaction_amount

  def amount
    Money.new( amount_cents, currency ).format
  end

  def balance
    Money.new( balance_cents, currency ).format
  end

  def paid
    Money.new( paid_cents, currency ).format
  end

  def total
    Money.new( total_cents, currency ).format
  end

  def to_s
    "Purchase ##{id}"
  end
end
