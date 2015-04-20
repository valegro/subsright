json.array!(@offers) do |offer|
  json.extract! offer, :id, :name, :finish
  json.url offer_url(offer, format: :json)
end
