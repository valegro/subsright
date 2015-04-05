xml.instruct!
xml.publication do
  xml.id @publication.id
  xml.name @publication.name
  xml.website @publication.stock
  xml.image @publication.image
  xml.description @publication.description
  xml.created_at @publication.created_at
  xml.updated_at @publication.updated_at
end
