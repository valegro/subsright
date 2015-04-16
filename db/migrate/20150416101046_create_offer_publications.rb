class CreateOfferPublications < ActiveRecord::Migration
  def change
    create_table :offer_publications do |t|
      t.belongs_to :offer, foreign_key: true
      t.belongs_to :publication, foreign_key: true
      t.integer :quantity, null: false
      t.string :unit, null: false

      t.timestamps null: false
      t.index [:offer_id, :publication_id], unique: true
    end
  end
end
