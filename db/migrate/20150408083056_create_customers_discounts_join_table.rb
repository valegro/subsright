class CreateCustomersDiscountsJoinTable < ActiveRecord::Migration
  def change
    create_join_table :customers, :discounts do |t|
      t.string :reference
      t.date :expiry
      t.index [:customer_id, :discount_id], unique: true
    end
  end
end
