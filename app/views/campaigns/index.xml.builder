xml.instruct!
xml.campaigns do
  @campaigns.each do |campaign|
    xml.campaign do
      xml.id campaign.id
      xml.name campaign.name
      xml.finish campaign.finish
      xml.url campaign_url(campaign, format: :xml)
    end
  end
end
