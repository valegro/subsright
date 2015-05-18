require 'test_helper'

class PriceTest < ActiveSupport::TestCase
  test 'should not save a price without a currency' do
    price = Price.new( name: 'Test', amount: '0' )
    assert_not price.save
  end
  test 'should not save a price without a name' do
    price = Price.new( currency: 'TST', amount: '0' )
    assert_not price.save
  end
  test 'should not save a price without an amount' do
    price = Price.new( currency: 'TST', name: 'Test' )
    assert_not price.save
  end
  test 'should save a price with a valid currency, name and amount' do
    price = Price.new( currency: 'TST', name: 'Test', amount: '0' )
    assert price.save
  end
end
