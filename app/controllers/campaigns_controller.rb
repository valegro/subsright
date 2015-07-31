class CampaignsController < InheritedResources::Base
  respond_to :html, :json, :xml

  def index
    @campaigns = Campaign.where(
      '(start IS NULL OR start <= CURRENT_DATE) AND (finish IS NULL OR finish >= CURRENT_DATE)'
    ).order(:finish, :name)
  end
end
