class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.belongs_to :offer, null:false, index: true, foreign_key: true
      t.string :currency, null: false
      t.integer :amount_cents, null: false
      t.datetime :completed_at
      t.string :receipt

      t.timestamps null: false
    end
  end
end
