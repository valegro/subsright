class CreateOfferProducts < ActiveRecord::Migration
  def change
    create_table :offer_products do |t|
      t.references :offer, foreign_key: true
      t.references :product, foreign_key: true
      t.boolean :optional, default: false, null: false

      t.timestamps null: false
      t.index [:offer_id, :product_id], unique: true
    end
  end
end
