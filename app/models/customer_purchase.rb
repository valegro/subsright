class CustomerPurchase < ActiveRecord::Base
  belongs_to :customer
  belongs_to :purchase
  validates :customer, presence: true
  validates :purchase, presence: true
end
