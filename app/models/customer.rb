class Customer < ActiveRecord::Base
  belongs_to :user

  has_many :customer_discounts
  accepts_nested_attributes_for :customer_discounts, allow_destroy: true
  has_many :discounts, through: :customer_discounts
  accepts_nested_attributes_for :discounts

  has_many :customer_subscriptions
  has_many :subscriptions, through: :customer_subscriptions
  accepts_nested_attributes_for :subscriptions, allow_destroy: true
  has_many :publications, through: :subscriptions
  accepts_nested_attributes_for :publications

  has_many :renewals, through: :subscriptions
  has_many :purchases, through: :renewals

  has_many :product_orders

  validates :name, presence: true
  validates :name, uniqueness: { scope: :email }, unless: 'email.blank?'

  attr_accessor :product_id

  # This will attempt to translate the country name and use the default
  # (usually English) name if no translation is available
  def country_name
    c = ISO3166::Country[country]
    c.translations[I18n.locale.to_s] || c.name
  end
end
