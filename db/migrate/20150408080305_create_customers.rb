class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name, null: false
      t.string :email
      t.string :phone
      t.text :address
      t.string :country
      t.string :postcode
      t.string :currency

      t.timestamps null: false
    end
  end
end
