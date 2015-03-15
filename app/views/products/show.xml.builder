xml.instruct!
xml.product do
  xml.id @product.id
  xml.name @product.name
  xml.stock @product.stock
  xml.image @product.image
  xml.description @product.description
  xml.created_at @product.created_at
  xml.updated_at @product.updated_at
end
