class CreateCampaignsOffersJoinTable < ActiveRecord::Migration
  def change
    create_join_table :campaigns, :offers do |t|
      t.index [:campaign_id, :offer_id], unique: true
    end
  end
end
