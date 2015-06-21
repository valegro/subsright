class CreateCustomerSubscriptions < ActiveRecord::Migration
  def change
    create_table :customer_subscriptions do |t|
      t.references :customer, foreign_key: true
      t.references :subscription, foreign_key: true

      t.timestamps null: false
      t.index [:customer_id, :subscription_id], unique: true
      t.index [:subscription_id, :customer_id], unique: true
    end
  end
end
