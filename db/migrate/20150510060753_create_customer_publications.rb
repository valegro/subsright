class CreateCustomerPublications < ActiveRecord::Migration
  def change
    create_table :customer_publications do |t|
      t.references :customer, foreign_key: true
      t.references :publication, foreign_key: true
      t.date :subscribed, null: false
      t.date :expiry

      t.timestamps null: false
      t.index [:customer_id, :publication_id], unique: true
    end
  end
end
