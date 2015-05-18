require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  test 'should not save an customer without a name' do
    customer = Customer.new()
    assert_not customer.save
  end
  test 'should save an customer with a valid name' do
    customer = Customer.new( name: 'Test' )
    assert customer.save
  end
end
