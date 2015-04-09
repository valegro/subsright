class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :stock
      t.attachment :image
      t.text :description

      t.timestamps null: false
    end
    add_index :products, :name, unique: true
  end
end
