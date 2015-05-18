require 'test_helper'

class CustomerPublicationTest < ActiveSupport::TestCase
  def setup
    @c ||= Customer.create!( name: 'Test' )
  end

  test 'should not save a customer publication without a publication' do
    cp = CustomerPublication.new( customer: @c, subscribed: Date.today )
    assert_not cp.save
  end
  test 'should not save a customer publication without a subscribed date' do
    p = Publication.create!( name: 'Test', website: 'http://example.com/' )
    cp = CustomerPublication.new( customer: @c, publication: p )
    assert_not cp.save
  end
  test 'should save a customer publication with a publication and subscribed date' do
    p = Publication.create!( name: 'Test', website: 'http://example.com/' )
    cp = CustomerPublication.new( customer: @c, publication: p, subscribed: Date.today )
    assert cp.save
  end
end
