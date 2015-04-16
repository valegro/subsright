require 'test_helper'

class OfferPublicationTest < ActiveSupport::TestCase
  test "should not save an offer publication without a publication" do
    op = OfferPublication.new( quantity: 1, unit: 'Month' )
    assert_not op.save
  end
  test "should not save an offer publication without a quantity" do
    p = Publication.create!( name: 'Test', website: 'http://example.com/' )
    op = OfferPublication.new( publication: p, unit: 'Month' )
    assert_not op.save
  end
  test "should not save an offer publication without a unit" do
    p = Publication.create!( name: 'Test', website: 'http://example.com/' )
    op = OfferPublication.new( publication: p, quantity: 1 )
    assert_not op.save
  end
  test "should save an offer publication with a publication, a quantity and a unit" do
    p = Publication.create!( name: 'Test', website: 'http://example.com/' )
    op = OfferPublication.new( publication: p, quantity: 1, unit: 'Month' )
    assert op.save
  end
end