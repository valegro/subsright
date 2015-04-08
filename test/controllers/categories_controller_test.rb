require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  setup do
    # Creates a reference to the admin controller
    @controller = ::Admin::CategoriesController.new

    # Prevents checking for a valid user session (pretends we're logged in)
    @controller.stubs(:authenticate_active_admin_user)

    @category = categories(:one)
    @category.name = 'New category'
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create category" do
    assert_difference('Category.count') do
      post :create, category: { name: @category.name }
    end

    assert_redirected_to admin_category_path(assigns(:category))
  end

  test "should show category" do
    get :show, id: @category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @category
    assert_response :success
  end

  test "should update category" do
    patch :update, id: @category, category: { name: @category.name }
    assert_redirected_to admin_category_path(assigns(:category))
  end

  test "should destroy category" do
    assert_difference('Category.count', -1) do
      delete :destroy, id: @category
    end

    assert_redirected_to admin_categories_path
  end
end
