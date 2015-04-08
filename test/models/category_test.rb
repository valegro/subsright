require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test "should not save a category without a name" do
    category = Category.new()
    assert_not category.save
  end
  test "should save a category with a valid name" do
    category = Category.new( name: 'Test' )
    assert category.save
  end
end
