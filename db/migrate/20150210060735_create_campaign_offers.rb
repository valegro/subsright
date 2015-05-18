class CreateCampaignOffers < ActiveRecord::Migration
  def change
    create_table :campaign_offers do |t|
      t.belongs_to :campaign, null: false, foreign_key: true
      t.belongs_to :offer, null: false, foreign_key: true
      t.index [:campaign_id, :offer_id], unique: true
    end
  end
end
