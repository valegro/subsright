class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.text :name, null: false
      t.text :email
      t.text :phone
      t.text :address
      t.text :country
      t.text :postcode

      t.timestamps null: false
    end
  end
end
