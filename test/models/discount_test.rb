require 'test_helper'

class DiscountTest < ActiveSupport::TestCase
  test "should not save a discount without a name or requestable" do
    discount = Discount.new()
    assert_not discount.save
  end
  test "should save a discount with a valid name and requestable" do
    discount = Discount.new( name: 'Test', requestable: true )
    assert discount.save
  end
end
