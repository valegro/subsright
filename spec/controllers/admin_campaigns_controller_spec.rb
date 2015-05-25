require 'rails_helper'
include Devise::TestHelpers

RSpec.describe Admin::CampaignsController, type: :controller do
  before { sign_in AdminUser.first }
  let(:campaign) { create(:campaign) }

  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns @campaigns' do
      get :index
      expect(assigns(:campaigns)).to eq [campaign]
    end
    it('renders the index template') { expect(get :index).to render_template('index') }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new campaign' do
        expect { post :create, campaign: attributes_for(:campaign) }.to change(Campaign, :count).by(1)
      end
      it 'redirects to the new campaign' do
        post :create, campaign: attributes_for(:campaign)
        expect(response).to redirect_to admin_campaign_path(Campaign.last)
      end
    end
    context 'with invalid attributes' do
      it 'does not save the new campaign' do
        expect { post :create, campaign: nil }.not_to change(Campaign, :count)
      end
      it('re-renders the new method') { expect(post :create, campaign: nil).to render_template('new') }
    end
  end

  describe 'GET #new' do
    it('responds successfully') { expect(get :new).to be_success }
    it('renders the new template') { expect(get :new).to render_template('new') }
  end

  describe 'GET #edit' do
    it('responds successfully') { expect(get :edit, id: campaign).to be_success }
    it('renders the edit template') { expect(get :edit, id: campaign).to render_template('edit') }
  end

  describe 'GET #show' do
    it('responds successfully') { expect(get :show, id: campaign).to be_success }
    it 'assigns the requested campaign to @campaign' do
      get :show, id: campaign
      expect(assigns(:campaign)).to eq campaign
    end
    it('renders the show template') { expect(get :show, id: campaign).to render_template('show') }
  end

  describe 'PATCH #update' do
    before { campaign }
    context 'with valid attributes' do
      it 'locates the requested campaign' do
        patch :update, id: campaign, campaign: attributes_for(:campaign)
        expect(assigns(:campaign)).to eq campaign
      end
      it "changes the campaign's attributes" do
        new_attributes = attributes_for(:campaign)
        patch :update, id: campaign, campaign: new_attributes
        campaign.reload
        expect(campaign.name).to eq new_attributes[:name]
      end
      it 'redirects to the updated campaign' do
        patch :update, id: campaign, campaign: attributes_for(:campaign)
        expect(response).to redirect_to admin_campaign_path(campaign)
      end
    end
    context 'with invalid attributes' do
      it 'locates the requested campaign' do
        patch :update, id: campaign, campaign: nil
        expect(assigns(:campaign)).to eq campaign
      end
      it "does not change the campaign's attributes" do
        name = campaign.name
        patch :update, id: campaign, campaign: nil
        campaign.reload
        expect(campaign.name).to eq name
      end
      it 'redirects back to the campaign' do
        patch :update, id: campaign, campaign: nil
        expect(response).to redirect_to admin_campaign_path(campaign)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { campaign }
    it('deletes the campaign') { expect { delete :destroy, id: campaign }.to change(Campaign, :count).by(-1) }
    it('redirects to campaigns#index') { expect(delete :destroy, id: campaign).to redirect_to admin_campaigns_path }
  end

  describe 'POST #batch_action' do
    let(:campaigns) { [create(:campaign), create(:campaign)] }
    before { campaigns }
    it('deletes the campaigns') do
      expect do
        post :batch_action,
          batch_action: 'destroy',
          collection_selection_toggle_all: 'on',
          collection_selection: campaigns
      end.to change(Campaign, :count).by(-2)
    end
    it('redirects to campaigns#index') do
      post :batch_action,
        batch_action: 'destroy',
        collection_selection_toggle_all: 'on',
        collection_selection: campaigns
      expect(response).to redirect_to admin_campaigns_path
    end
  end
end
