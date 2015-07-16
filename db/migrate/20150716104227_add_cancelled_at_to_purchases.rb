class AddCancelledAtToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :cancelled_at, :datetime
  end
end
