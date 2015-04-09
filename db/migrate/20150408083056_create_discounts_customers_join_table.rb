class CreateDiscountsCustomersJoinTable < ActiveRecord::Migration
  def change
    create_join_table :discounts, :customers do |t|
      t.text :reference
      t.date :expiry
      t.index [:customer_id, :discount_id], unique: true
    end
  end
end
