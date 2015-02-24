class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.text :name, null: false
      t.integer :stock

      t.timestamps null: false
    end
  end
end
