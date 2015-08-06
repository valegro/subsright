class ProductOrder < ActiveRecord::Base
  belongs_to :customer
  belongs_to :purchase
  belongs_to :product
  counter_culture :product,
    column_name: proc { |model| ( model.shipped.present? ? 'shipped' : 'unshipped' ) + '_count' },
    column_names: {
      ['product_orders.shipped IS NOT NULL'] => 'shipped_count',
      ['product_orders.shipped IS NULL'] => 'unshipped_count'
    }

  validates :customer, presence: true
  validates :purchase, presence: true
  validates :product, presence: true
end
