class AddColumnsToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :monthly_payments, :integer
    add_column :purchases, :initial_amount_cents, :integer
    add_column :purchases, :payment_due, :date
    remove_column :purchases, :completed_at, :timestamp
    remove_index :purchases, :receipt
    rename_column :purchases, :receipt, :token
  end
end
