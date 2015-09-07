class AddPaidCentsToPurchases < ActiveRecord::Migration
  def self.up
    add_column :purchases, :paid_cents,     :integer, null: false, default: 0
    execute 'UPDATE purchases p
      SET paid_cents = (SELECT COALESCE(SUM(t.amount_cents), 0) FROM transactions t WHERE p.id = purchase_id);'
  end

  def self.down
    remove_column :purchases, :paid_cents
  end
end
