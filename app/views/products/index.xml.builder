xml.instruct!
xml.products do
  @products.each do |product|
    xml.product do
      xml.id product.id
      xml.name product.name
      xml.image product.image(:thumb)
      xml.url product_url(product, format: :xml)
    end
  end
end
