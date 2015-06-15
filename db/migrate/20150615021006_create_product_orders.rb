class CreateProductOrders < ActiveRecord::Migration
  def change
    create_table :product_orders do |t|
      t.belongs_to :customer, foreign_key: true
      t.belongs_to :purchase, foreign_key: true
      t.belongs_to :product, index: true, foreign_key: true
      t.date :shipped

      t.timestamps null: false
      t.index [:customer_id, :purchase_id, :product_id], unique: true,
        name: 'index_product_orders_on_customer_purchase_and_product_ids'
    end
  end
end
