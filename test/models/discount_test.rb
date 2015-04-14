require 'test_helper'

class DiscountTest < ActiveSupport::TestCase
  test "should not save a discount without a name" do
    discount = Discount.new()
    assert_not discount.save
  end
  test "should save a discount with a valid name" do
    discount = Discount.new( name: 'Test' )
    assert discount.save
  end
end
