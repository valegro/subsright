class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.belongs_to :publication, null: false, foreign_key: true, index: true
      t.belongs_to :user, foreign_key: true, index: true
      t.integer :subscribers, null: false
      t.date :subscribed, null: false
      t.date :expiry
      t.text :cancellation_reason

      t.timestamps null: false
    end
  end
end
