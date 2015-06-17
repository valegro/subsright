class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.belongs_to :user, foreign_key: true
      t.string :name, null: false
      t.string :email
      t.string :phone
      t.text :address
      t.string :country
      t.string :postcode

      t.timestamps null: false
    end

    add_index :customers, [:email, :name]
  end
end
