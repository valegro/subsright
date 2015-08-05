class Subscription < ActiveRecord::Base
  belongs_to :publication
  counter_culture :publication
  accepts_nested_attributes_for :publication
  belongs_to :user

  has_many :customer_subscriptions
  has_many :customers, through: :customer_subscriptions
  accepts_nested_attributes_for :customers
  has_many :payments

  validates :publication, presence: true
  validates :subscribers, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :subscribed, presence: true
  scope :by_name, -> { joins(:publication).order('publications.name') }

  def to_s
    description = publication.name
    return "#{description} (no subscribers)" unless customers.exists?

    description += ' for ' + ( subscribers > 1 ? "#{subscribers} subscribers" : customers.first.name )
    return "#{description} (permanent)" unless expiry

    status = 'expires'
    status = cancellation_reason.present? ? 'cancelled' : 'expired' if expiry <= Time.zone.today
    "#{description} (#{status} on #{I18n.l expiry, format: :long})"
  end
end
