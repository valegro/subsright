class OfferPublication < ActiveRecord::Base
  belongs_to :offer
  accepts_nested_attributes_for :offer
  belongs_to :publication
  accepts_nested_attributes_for :publication
  validates :publication, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit, presence: true
  scope :by_name, -> { joins(:publication).order('publications.name') }

  UNITS = ['Week', ['Month', 'Month', { checked: true }], 'Year']
end
