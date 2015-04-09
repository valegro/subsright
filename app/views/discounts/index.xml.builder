xml.instruct!
xml.discounts do
  @discounts.each do |discount|
    xml.discount do
      xml.id discount.id
      xml.name discount.name
    end
  end
end
