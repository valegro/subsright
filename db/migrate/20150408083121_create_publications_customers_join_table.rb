class CreatePublicationsCustomersJoinTable < ActiveRecord::Migration
  def change
    create_join_table :publications, :customers do |t|
      t.date :subscribed, null: false
      t.date :expires
      t.index [:customer_id, :publication_id], unique: true
    end
  end
end
