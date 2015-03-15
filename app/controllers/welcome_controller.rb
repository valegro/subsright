class WelcomeController < ApplicationController
  def index
    @campaigns = Campaign.joins(:offers).where(
      '(start IS NULL OR start <= NOW()) AND (finish IS NULL OR finish >= NOW())'
    ).group('campaigns.id').having(
      'COUNT( offers.expires IS NULL OR offers.expires >= NOW() ) > 0'
    ).order(:finish, :name)
  end
end
