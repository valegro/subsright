require 'test_helper'

class DiscountsControllerTest < ActionController::TestCase
  setup do
    # Creates a reference to the admin controller
    @controller = ::Admin::DiscountsController.new

    # Prevents checking for a valid user session (pretends we're logged in)
    @controller.stubs(:authenticate_active_admin_user)

    @discount = discounts(:one)
    @discount.name = 'New discount'
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:discounts)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create discount' do
    assert_difference('Discount.count') do
      post :create, discount: { name: @discount.name, requestable: @discount.requestable }
    end

    assert_redirected_to admin_discount_path(assigns(:discount))
  end

  test 'should show discount' do
    get :show, id: @discount
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @discount
    assert_response :success
  end

  test 'should update discount' do
    patch :update, id: @discount, discount: { name: @discount.name }
    assert_redirected_to admin_discount_path(assigns(:discount))
  end

  test 'should destroy discount' do
    assert_difference('Discount.count', -1) do
      delete :destroy, id: @discount
    end

    assert_redirected_to admin_discounts_path
  end
end
