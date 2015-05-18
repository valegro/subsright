require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    # Creates a reference to the admin controller
    @controller = ::Admin::ProductsController.new

    # Prevents checking for a valid user session (pretends we're logged in)
    @controller.stubs(:authenticate_active_admin_user)

    @product = products(:one)
    @product.name = 'New Product'
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create product' do
    assert_difference('Product.count') do
      post :create, product: { name: @product.name, stock: @product.stock }
    end

    assert_redirected_to admin_product_path(assigns(:product))
  end

  test 'should show product' do
    get :show, id: @product
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @product
    assert_response :success
  end

  test 'should update product' do
    patch :update, id: @product, product: { name: @product.name, stock: @product.stock }
    assert_redirected_to admin_product_path(assigns(:product))
  end

  test 'should destroy product' do
    assert_difference('Product.count', -1) do
      delete :destroy, id: @product
    end

    assert_redirected_to admin_products_path
  end
end
