class CreateOffersPricesJoinTable < ActiveRecord::Migration
  def change
    create_table :offers_prices, id: false do |t|
      t.belongs_to :offer, null: false, foreign_key: true
      t.belongs_to :price, null: false, foreign_key: true
      t.index [:offer_id, :price_id], unique: true
    end
  end
end
