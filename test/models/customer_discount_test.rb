require 'test_helper'

class CustomerDiscountTest < ActiveSupport::TestCase
  def setup
    @c ||= Customer.create!( name: 'Test' )
  end

  test "should not save a customer discount without a discount" do
    cd = CustomerDiscount.new( customer: @c )
    assert_not cd.save
  end
  test "should save a customer discount with a discount" do
    d = Discount.create!( name: 'Test' )
    cd = CustomerDiscount.new( customer: @c, discount: d )
    assert cd.save
  end
end
