class Customer < ActiveRecord::Base
  belongs_to :user

  has_many :customer_discounts
  accepts_nested_attributes_for :customer_discounts, allow_destroy: true
  has_many :discounts, through: :customer_discounts
  accepts_nested_attributes_for :discounts

  has_many :subscriptions
  accepts_nested_attributes_for :subscriptions, allow_destroy: true
  has_many :publications, through: :subscriptions
  accepts_nested_attributes_for :publications

  has_many :payments, through: :subscriptions
  has_many :purchases, through: :payments

  validates :name, presence: true

  # This will attempt to translate the country name and use the default
  # (usually English) name if no translation is available
  def country_name
    c = ISO3166::Country[country]
    c.translations[I18n.locale.to_s] || c.name
  end

  def currency_name
    m = Money::Currency.new(currency)
    "#{m.name} (#{m.iso_code})"
  end
end
