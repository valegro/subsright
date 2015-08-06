class AddOrderCountsToProducts < ActiveRecord::Migration

  def self.up
    add_column :products, :shipped_count, :integer, null: false, default: 0
    add_column :products, :unshipped_count, :integer, null: false, default: 0
    execute 'UPDATE products SET shipped_count = sc, unshipped_count = uc
      FROM (
        SELECT product_id, COUNT(shipped) AS sc, COUNT(*) - COUNT(shipped) AS uc
        FROM product_orders GROUP BY product_id
      ) AS c
      WHERE products.id = product_id;'
  end

  def self.down
    remove_column :products, :shipped_count
    remove_column :products, :unshipped_count
  end

end
