class WelcomeController < ApplicationController
  def index
    @campaigns = Campaign.joins(:offers).where(
      '(campaigns.start IS NULL OR campaigns.start <= CURRENT_DATE)
       AND (campaigns.finish IS NULL OR campaigns.finish >= CURRENT_DATE)'
    ).group('campaigns.id').having(
      'COUNT( (offers.start IS NULL OR offers.start <= CURRENT_DATE)
         AND (offers.finish IS NULL OR offers.finish >= CURRENT_DATE) ) > 0'
    ).order(:finish, :name)
  end
end
