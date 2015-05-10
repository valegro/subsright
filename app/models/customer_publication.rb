class CustomerPublication < ActiveRecord::Base
  belongs_to :customer
  accepts_nested_attributes_for :customer
  belongs_to :publication
  accepts_nested_attributes_for :publication
  validates_presence_of :publication, :subscribed
  scope :by_name, lambda { joins(:publication).order('publications.name') }
end
