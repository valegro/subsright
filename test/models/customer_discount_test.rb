require 'test_helper'

class CustomerDiscountTest < ActiveSupport::TestCase
  test "should not save a customer discount without a discount" do
    cd = CustomerDiscount.new()
    assert_not cd.save
  end
  test "should save a customer discount with a discount" do
    d = Discount.create!( name: 'Test' )
    cd = CustomerDiscount.new( discount: d )
    assert cd.save
  end
end
