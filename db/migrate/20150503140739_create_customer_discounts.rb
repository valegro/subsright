class CreateCustomerDiscounts < ActiveRecord::Migration
  def change
    create_table :customer_discounts do |t|
      t.references :customer, foreign_key: true
      t.references :discount, foreign_key: true
      t.string :reference
      t.date :expiry

      t.timestamps null: false
      t.index [:customer_id, :discount_id], unique: true
    end
  end
end
