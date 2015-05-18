class CampaignOffer < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :offer
end
