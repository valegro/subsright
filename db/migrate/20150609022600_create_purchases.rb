class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.belongs_to :offer, null:false, index: true, foreign_key: true
      t.string :price_name, null: false
      t.string :discount_name
      t.string :currency, null: false
      t.integer :amount_cents, null: false
      t.datetime :completed_at

      t.timestamps null: false
    end
  end
end
