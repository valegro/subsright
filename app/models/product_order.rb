class ProductOrder < ActiveRecord::Base
  belongs_to :customer
  belongs_to :purchase
  belongs_to :product
  validates :customer, presence: true
  validates :purchase, presence: true
  validates :product, presence: true
end
