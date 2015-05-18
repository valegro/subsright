require 'test_helper'

class CampaignTest < ActiveSupport::TestCase
  test 'should not save a campaign without a name' do
    campaign = Campaign.new()
    assert_not campaign.save
  end
  test 'should save a campaign with a valid name' do
    campaign = Campaign.new( name: 'Test' )
    assert campaign.save
  end
end
