require 'test_helper'

class CampaignsControllerTest < ActionController::TestCase
  setup do
    # Creates a reference to the admin controller
    @controller = ::Admin::CampaignsController.new

    # Prevents checking for a valid user session (pretends we're logged in)
    @controller.stubs(:authenticate_active_admin_user)

    @campaign = campaigns(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:campaigns)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create campaign' do
    assert_difference('Campaign.count') do
      post :create, campaign: { finish: @campaign.finish, name: @campaign.name, start: @campaign.start }
    end

    assert_redirected_to admin_campaign_path(assigns(:campaign))
  end

  test 'should show campaign' do
    get :show, id: @campaign
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @campaign
    assert_response :success
  end

  test 'should update campaign' do
    patch :update, id: @campaign, campaign: { finish: @campaign.finish, name: @campaign.name, start: @campaign.start }
    assert_redirected_to admin_campaign_path(assigns(:campaign))
  end

  test 'should destroy campaign' do
    assert_difference('Campaign.count', -1) do
      delete :destroy, id: @campaign
    end

    assert_redirected_to admin_campaigns_path
  end
end
