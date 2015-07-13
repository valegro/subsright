class AddReceiptIndexToPurchases < ActiveRecord::Migration
  def change
    add_index :purchases, :receipt
  end
end
