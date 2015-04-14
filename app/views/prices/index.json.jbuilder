json.array!(@prices) do |price|
  json.extract! price, :id, :currency, :name, :amount
end
