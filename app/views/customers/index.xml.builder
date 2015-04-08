xml.instruct!
xml.customers do
  @customers.each do |customer|
    xml.customer do
      xml.id customer.id
      xml.name customer.name
      xml.email customer.email
      xml.phone customer.phone
      xml.address customer.address
      xml.country customer.country
      xml.url customer_url(customer, format: :xml)
    end
  end
end
