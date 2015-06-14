class Subscription < ActiveRecord::Base
  belongs_to :customer
  accepts_nested_attributes_for :customer
  belongs_to :publication
  accepts_nested_attributes_for :publication
  has_many :payments

  validates :publication, presence: true
  validates :subscribed, presence: true
  scope :by_name, -> { joins(:publication).order('publications.name') }
end
