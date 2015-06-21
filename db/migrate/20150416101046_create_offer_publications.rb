class CreateOfferPublications < ActiveRecord::Migration
  def change
    create_table :offer_publications do |t|
      t.belongs_to :offer, null: false, foreign_key: true
      t.belongs_to :publication, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.string :unit, null: false
      t.integer :subscribers, null: false, default: 1

      t.timestamps null: false
      t.index [:offer_id, :publication_id], unique: true
    end
  end
end
