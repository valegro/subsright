class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.string :name, null: false
      t.boolean :requestable

      t.timestamps null: false
    end
    add_index :discounts, :name, unique: true
  end
end
