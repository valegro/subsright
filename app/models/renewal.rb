class Renewal < ActiveRecord::Base
  belongs_to :purchase
  belongs_to :subscription

  validates :purchase, presence: true
  validates :subscription, presence: true
  validates :price_name, presence: true

  def to_s
    "#{price_name}: #{subscription.publication.name}"
  end
end
