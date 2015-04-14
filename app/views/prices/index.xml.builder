xml.instruct!
xml.prices do
  @prices.each do |price|
    xml.price do
      xml.id price.id
      xml.currency price.currency
      xml.name price.name
      xml.amount price.amount
    end
  end
end
