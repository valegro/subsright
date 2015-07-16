class OfferPublication < ActiveRecord::Base
  belongs_to :offer
  accepts_nested_attributes_for :offer
  belongs_to :publication
  accepts_nested_attributes_for :publication
  validates :publication, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit, presence: true, inclusion: { in: %w(Day Week Month Year) }
  validates :subscribers, presence: true, numericality: { only_integer: true, greater_than: 0 }
  scope :by_name, -> { joins(:publication).order('publications.name') }

  UNITS = ['Day', 'Week', ['Month', 'Month', { checked: true }], 'Year']

  def extend_date(date)
    date.advance(unit.pluralize.downcase.to_sym => quantity)
  end

  def reduce_date(date)
    date.advance(unit.pluralize.downcase.to_sym => -quantity)
  end
end
