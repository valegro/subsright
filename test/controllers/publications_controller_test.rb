require 'test_helper'

class PublicationsControllerTest < ActionController::TestCase
  setup do
    # Creates a reference to the admin controller
    @controller = ::Admin::PublicationsController.new

    # Prevents checking for a valid user session (pretends we're logged in)
    @controller.stubs(:authenticate_active_admin_user)

    @publication = publications(:one)
    @publication.name = 'New Publication'
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:publications)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create publication' do
    assert_difference('Publication.count') do
      post :create, publication: {
        website: @publication.website,
        description: @publication.description,
        name: @publication.name
      }
    end

    assert_redirected_to admin_publication_path(assigns(:publication))
  end

  test 'should show publication' do
    get :show, id: @publication
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @publication
    assert_response :success
  end

  test 'should update publication' do
    patch :update, id: @publication, publication: {
      website: @publication.website,
      description: @publication.description,
      name: @publication.name
    }
    assert_redirected_to admin_publication_path(assigns(:publication))
  end

  test 'should destroy publication' do
    assert_difference('Publication.count', -1) do
      delete :destroy, id: @publication
    end

    assert_redirected_to admin_publications_path
  end
end
