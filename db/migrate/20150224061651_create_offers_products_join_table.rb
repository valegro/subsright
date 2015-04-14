class CreateOffersProductsJoinTable < ActiveRecord::Migration
  def change
    create_join_table :offers, :products do |t|
      t.boolean :optional
      t.index [:offer_id, :product_id], unique: true
    end
  end
end
