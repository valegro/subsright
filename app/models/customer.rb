class Customer < ActiveRecord::Base
  has_and_belongs_to_many :discounts
  accepts_nested_attributes_for :discounts
  has_and_belongs_to_many :publications
  accepts_nested_attributes_for :publications
  validates_presence_of :name

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