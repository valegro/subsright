json.array!(@publications) do |publication|
  json.extract! publication, :id, :name, :website
  json.image publication.image(:thumb)
  json.url publication_url(publication, format: :json)
end
