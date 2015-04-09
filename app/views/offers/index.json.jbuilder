json.array!(@offers) do |offer|
  json.extract! offer, :id, :name, :expiry
  json.url offer_url(offer, format: :json)
end
