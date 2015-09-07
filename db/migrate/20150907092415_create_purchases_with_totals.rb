class CreatePurchasesWithTotals < ActiveRecord::Migration
  def up
    execute 'CREATE FUNCTION total_cents(purchases) RETURNS integer AS $func$
      SELECT COALESCE($1.initial_amount_cents, 0) + ($1.amount_cents * COALESCE($1.monthly_payments, 1))
      $func$ LANGUAGE SQL STABLE;'
    execute 'CREATE VIEW purchases_with_totals AS
      SELECT *, purchases.id AS purchase_id, purchases.total_cents, purchases.total_cents - paid_cents AS balance_cents
      FROM purchases;'
  end

  def down
    execute 'DROP VIEW purchases_with_totals;'
    execute 'DROP FUNCTION total_cents(purchases);'
  end
end
