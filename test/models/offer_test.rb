require 'test_helper'

class OfferTest < ActiveSupport::TestCase
  test "should not save an offer without a name" do
    offer = Offer.new()
    assert_not offer.save
  end
  test "should save an offer with a valid name" do
    offer = Offer.new( name: 'Test' )
    assert offer.save
  end
end
