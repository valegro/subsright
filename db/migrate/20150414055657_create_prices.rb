class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.string :currency, null: false
      t.string :name, null: false
      t.integer :amount_cents, null: false
      t.integer :monthly_payments
      t.integer :initial_amount_cents

      t.timestamps null: false
    end

    add_index :prices, [:currency, :name], unique: true
  end
end
