class Customer < ActiveRecord::Base
  has_many :discounts, through: :customer_discounts
  accepts_nested_attributes_for :discounts
  has_many :customer_discounts
  accepts_nested_attributes_for :customer_discounts, allow_destroy: true

  has_many :publications, through: :customer_publications
  accepts_nested_attributes_for :publications
  has_many :customer_publications
  accepts_nested_attributes_for :customer_publications, allow_destroy: true

  validates :name, presence: true

  # This will attempt to translate the country name and use the default
  # (usually English) name if no translation is available
  def country_name
    c = ISO3166::Country[country]
    c.translations[I18n.locale.to_s] || c.name
  end

  def currencies
    Money::Currency.table.map { |m| [ "#{m[1][:name]} (#{m[1][:iso_code]})", m[1][:iso_code] ] }
  end

  def currency_name
    m = Money::Currency.new(currency)
    "#{m.name} (#{m.iso_code})"
  end
end
