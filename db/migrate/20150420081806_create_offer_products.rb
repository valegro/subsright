class CreateOfferProducts < ActiveRecord::Migration
  def change
    create_table :offer_products do |t|
      t.belongs_to :offer, null: false, foreign_key: true
      t.belongs_to :product, null: false, foreign_key: true
      t.boolean :optional, default: false, null: false

      t.timestamps null: false
      t.index [:offer_id, :product_id], unique: true
    end
  end
end
