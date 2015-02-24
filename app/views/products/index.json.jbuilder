json.array!(@products) do |product|
  json.extract! product, :id, :name, :stock
  json.url product_url(product, format: :json)
end
