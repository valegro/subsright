class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.belongs_to :purchase, null: false, foreign_key: true
      t.integer :amount_cents
      t.string :message, null: false, index: true

      t.timestamps null: false
    end
  end
end
