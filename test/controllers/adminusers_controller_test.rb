require 'test_helper'

class AdminUsersControllerTest < ActionController::TestCase
  setup do
    # Creates a reference to the admin controller
    @controller = ::Admin::AdminUsersController.new 

    # Prevents checking for a valid user session (pretends we're logged in)
    @controller.stubs(:authenticate_active_admin_user)

    @admin_user = admin_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin user" do
    assert_difference('AdminUser.count') do
      post :create, admin_user: { name: 'Test', email: 'test@example.com', password: 'password', password_confirmation: 'password' }
    end

    assert_redirected_to admin_admin_user_path(assigns(:admin_user))
  end

  test "should show admin user" do
    get :show, id: @admin_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_user
    assert_response :success
  end

  test "should update admin user" do
    patch :update, id: @admin_user, admin_user: { name: @admin_user.name, email: @admin_user.email }
    assert_redirected_to admin_admin_user_path(assigns(:admin_user))
  end

  test "should destroy admin user" do
    assert_difference('AdminUser.count', -1) do
      delete :destroy, id: @admin_user
    end

    assert_redirected_to admin_admin_users_path
  end
end
