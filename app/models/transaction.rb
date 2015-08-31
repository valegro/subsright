class Transaction < ActiveRecord::Base
  belongs_to :purchase
  validates :message, presence: true
  validates :message, uniqueness: true, unless: 'amount_cents.nil?'

  def amount
    Money.new(amount_cents, purchase.currency).format
  end

  def amount=(amount)
    self.amount_cents = amount.tr('^0-9', '')
  end

  def to_s
    "#{I18n.l created_at, format: :long} #{message}" + (amount_cents ? " #{amount}" : '')
  end
end
