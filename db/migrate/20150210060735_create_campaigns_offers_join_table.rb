class CreateCampaignsOffersJoinTable < ActiveRecord::Migration
  def change
    create_table :campaigns_offers, id: false do |t|
      t.belongs_to :campaign, null: false, foreign_key: true
      t.belongs_to :offer, null: false, foreign_key: true
      t.index [:campaign_id, :offer_id], unique: true
    end
  end
end
