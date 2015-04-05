json.array!(@products) do |product|
  json.extract! product, :id, :name, :stock
  json.image product.image(:thumb)
  json.url product_url(product, format: :json)
end
