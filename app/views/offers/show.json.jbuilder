json.extract! @offer, :id, :name, :finish, :description
json.array(@offer.offer_publications) do |op|
  json.extract! op, :publication_id, :quantity, :unit
end
json.array(@offer.offer_products) do |op|
  json.extract! op, :product_id, :optional
end
json.extract! @offer, :created_at, :updated_at
