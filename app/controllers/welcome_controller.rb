class WelcomeController < ApplicationController
  def index
    @campaigns = Campaign.joins(:offers).where(
      '(campaigns.start IS NULL OR campaigns.start <= NOW())
       AND (campaigns.finish IS NULL OR campaigns.finish >= NOW())'
    ).group('campaigns.id').having(
      'COUNT( (offers.start IS NULL OR offers.start <= NOW())
         AND (offers.finish IS NULL OR offers.finish >= NOW()) ) > 0'
    ).order(:finish, :name)
  end
end
