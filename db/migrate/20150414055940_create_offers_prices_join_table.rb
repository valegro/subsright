class CreateOffersPricesJoinTable < ActiveRecord::Migration
  def change
    create_join_table :offers, :prices do |t|
      t.index [:offer_id, :price_id], unique: true
    end
  end
end
