class OfferPublication < ActiveRecord::Base
  belongs_to :offer
  accepts_nested_attributes_for :offer
  belongs_to :publication
  accepts_nested_attributes_for :publication
  validates_presence_of :publication, :quantity, :unit
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  scope :by_name, lambda { joins(:publication).order('publications.name') }

  UNITS = ['Week', ['Month', 'Month', {checked: true}], 'Year']
end
