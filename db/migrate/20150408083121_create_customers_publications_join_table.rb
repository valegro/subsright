class CreateCustomersPublicationsJoinTable < ActiveRecord::Migration
  def change
    create_join_table :customers, :publications do |t|
      t.date :subscribed, null: false
      t.date :expiry
      t.index [:customer_id, :publication_id], unique: true
    end
  end
end
