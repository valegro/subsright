require 'test_helper'

class AdminUserTest < ActiveSupport::TestCase
  test "should not save an admin user without an email address" do
    admin_user = AdminUser.new( :password => 'testpass' )
    assert_not admin_user.save
  end
  test "should not save an admin user with an invalid email address" do
    admin_user = AdminUser.new( :email => 'test@test', :password => 'testpass' )
    assert_not admin_user.save
  end
  test "should not save an admin user without a password" do
    admin_user = AdminUser.new( :email => 'test@example.com' )
    assert_not admin_user.save
  end
  test "should not save an admin user with a short password" do
    admin_user = AdminUser.new( :email => 'test@example.com', :password => 'test' )
    assert_not admin_user.save
  end
  test "should save an admin user with a valid email address and password" do
    admin_user = AdminUser.new( :email => 'test@example.com', :password => 'testpass' )
    assert admin_user.save
  end
end
