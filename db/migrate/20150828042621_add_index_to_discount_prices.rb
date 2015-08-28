class AddIndexToDiscountPrices < ActiveRecord::Migration
  def change
    add_index :discount_prices, [:price_id, :discount_id], unique: true
  end
end
