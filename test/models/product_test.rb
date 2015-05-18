require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test 'should not save a product without a name' do
    product = Product.new()
    assert_not product.save
  end
  test 'should save a product with a valid name' do
    product = Product.new( name: 'Test' )
    assert product.save
  end
end
