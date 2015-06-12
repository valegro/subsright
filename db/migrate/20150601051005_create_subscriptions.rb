class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.belongs_to :customer, null: false, foreign_key: true
      t.belongs_to :publication, null: false, foreign_key: true
      t.date :subscribed, null: false
      t.date :expiry
      t.text :cancellation_reason

      t.timestamps null: false
      t.index [:customer_id, :publication_id], unique: true
    end
  end
end
