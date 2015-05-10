class CreateDiscountsPricesJoinTable < ActiveRecord::Migration
  def change
    create_table :discounts_prices, id: false do |t|
      t.belongs_to :discount, null: false, foreign_key: true
      t.belongs_to :price, null: false, foreign_key: true
      t.index [:discount_id, :price_id], unique: true
    end
  end
end
