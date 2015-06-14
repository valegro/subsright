class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :purchase, foreign_key: true
      t.references :subscription, foreign_key: true
      t.string :price_name, null: false
      t.string :discount_name

      t.timestamps null: false
      t.index [:subscription_id, :purchase_id], unique: true
    end
  end
end
