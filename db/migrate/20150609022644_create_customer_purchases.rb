class CreateCustomerPurchases < ActiveRecord::Migration
  def change
    create_table :customer_purchases do |t|
      t.belongs_to :customer, null: false, foreign_key: true
      t.belongs_to :purchase, null: false, foreign_key: true
      t.index [:customer_id, :purchase_id], unique: true
    end
  end
end
