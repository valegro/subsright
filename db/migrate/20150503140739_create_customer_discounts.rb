class CreateCustomerDiscounts < ActiveRecord::Migration
  def change
    create_table :customer_discounts do |t|
      t.belongs_to :customer, null: false, foreign_key: true
      t.belongs_to :discount, null: false, foreign_key: true
      t.string :reference
      t.date :expiry

      t.timestamps null: false
      t.index [:customer_id, :discount_id], unique: true
    end
  end
end
