xml.instruct!
xml.publications do
  @publications.each do |publication|
    xml.publication do
      xml.id publication.id
      xml.name publication.name
      xml.website publication.website
      xml.image publication.image(:thumb)
      xml.url publication_url(publication, format: :xml)
    end
  end
end
