xml.instruct!
xml.offer do
  xml.id @offer.id
  xml.name @offer.name
  xml.finish @offer.finish
  xml.description @offer.description
  @offer.offer_publications.each do |op|
    xml.offer_publication do
      xml.publication_id op.publication_id
      xml.quantity op.quantity
      xml.unit op.unit
    end
  end
  xml.created_at @offer.created_at
  xml.updated_at @offer.updated_at
end
