json.array!(@discounts) do |discount|
  json.extract! discount, :id, :name
end
