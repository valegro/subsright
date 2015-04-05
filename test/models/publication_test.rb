require 'test_helper'

class PublicationTest < ActiveSupport::TestCase
  test "should not save a publication without a name" do
    publication = Publication.new( website: 'http://localhost/' )
    assert_not publication.save
  end
  test "should not save a publication without a website" do
    publication = Publication.new( name: 'Test' )
    assert_not publication.save
  end
  test "should not save a publication with an invalid website" do
    publication = Publication.new( name: 'Test', website: 'invalid' )
    assert_not publication.save
  end
  test "should save a publication with a valid name and website" do
    publication = Publication.new( name: 'Test', website: 'http://localhost/' )
    assert publication.save
  end
end
