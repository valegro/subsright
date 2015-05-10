xml.instruct!
xml.customer do
  xml.id @customer.id
  xml.name @customer.name
  xml.email @customer.email
  xml.phone @customer.phone
  xml.address @customer.address
  xml.country @customer.country
  xml.postcode @customer.postcode
  xml.currency @customer.currency
  @customer.customer_discounts.each do |cd|
    xml.customer_discount do
      xml.discount_id cd.discount_id
      xml.expiry cd.expiry
    end
  end
  @customer.customer_publications.each do |cp|
    xml.customer_publication do
      xml.publication_id cp.publication_id
      xml.expiry cp.expiry
    end
  end
  xml.created_at @customer.created_at
  xml.updated_at @customer.updated_at
end
