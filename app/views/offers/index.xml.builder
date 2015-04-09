xml.instruct!
xml.offers do
  @offers.each do |offer|
    xml.offer do
      xml.id offer.id
      xml.name offer.name
      xml.expiry offer.expiry
      xml.url offer_url(offer, format: :xml)
    end
  end
end
