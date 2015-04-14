class CreateDiscountsPricesJoinTable < ActiveRecord::Migration
  def change
    create_join_table :discounts, :prices do |t|
      t.index [:discount_id, :price_id], unique: true
    end
  end
end
