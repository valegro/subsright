class CreateProductsOffersJoinTable < ActiveRecord::Migration
  def change
    create_join_table :products, :offers do |t|
      t.index [:offer_id, :product_id], unique: true
    end
  end
end
