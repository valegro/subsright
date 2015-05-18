require 'test_helper'

class OfferProductTest < ActiveSupport::TestCase
  def setup
    @o ||= Offer.create!( name: 'Test' )
  end

  test 'should not save an offer product without a product' do
    op = OfferProduct.new( offer: @o )
    assert_not op.save
  end
  test 'should save an offer product with a product' do
    p = Product.create!( name: 'Test' )
    op = OfferProduct.new( offer: @o, product: p )
    assert op.save
  end
end
