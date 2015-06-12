json.extract! @customer, :id, :name, :email, :phone, :address, :country, :postcode, :currency
json.array(@customer.customer_discounts) do |cd|
  json.extract! cd, :discount_id, :expiry
end
json.array(@customer.subscriptions) do |s|
  json.extract! s, :publication_id, :expiry
end
json.extract! @customer, :created_at, :updated_at
