require 'test_helper'

class OfferProductTest < ActiveSupport::TestCase
  test "should not save an offer product without a product" do
    op = OfferProduct.new()
    assert_not op.save
  end
  test "should save an offer product with a product" do
    p = Product.create!( name: 'Test' )
    op = OfferProduct.new( product: p )
    assert op.save
  end
end
