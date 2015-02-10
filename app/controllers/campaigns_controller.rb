class CampaignsController < InheritedResources::Base

  private

    def campaign_params
      params.require(:campaign).permit(:name, :start, :finish)
    end
end
