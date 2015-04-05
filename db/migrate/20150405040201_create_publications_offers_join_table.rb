class CreatePublicationsOffersJoinTable < ActiveRecord::Migration
  def change
    create_join_table :publications, :offers do |t|
      t.integer :quantity
      t.string :unit
      t.index [:offer_id, :publication_id], unique: true
    end
  end
end
