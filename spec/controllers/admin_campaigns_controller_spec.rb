require 'rails_helper'

RSpec.describe Admin::CampaignsController, type: :controller do
  let(:admin_user) { create :admin_user, confirmed_at: Time.zone.now }
  before { sign_in admin_user }
  let(:campaign) { create :campaign }
  let(:invalid_attributes) { attributes_for :campaign, name: nil }

  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns @campaigns' do
      get :index
      expect(assigns :campaigns).to eq [campaign]
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
        expect { post :create, campaign: invalid_attributes }.not_to change(Campaign, :count)
      end
      it 're-renders the new template' do
        expect(post :create, campaign: invalid_attributes).to render_template('new')
      end
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
      expect(assigns :campaign).to eq campaign
    end
    it('renders the show template') { expect(get :show, id: campaign).to render_template('show') }
  end

  describe 'PATCH #update' do
    before { campaign }
    context 'with valid attributes' do
      it 'locates the requested campaign' do
        patch :update, id: campaign, campaign: attributes_for(:campaign)
        expect(assigns :campaign).to eq campaign
      end
      it "changes the campaign's attributes" do
        new_attributes = attributes_for :campaign
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
        patch :update, id: campaign, campaign: invalid_attributes
        expect(assigns :campaign).to eq campaign
      end
      it "does not change the campaign's attributes" do
        name = campaign.name
        patch :update, id: campaign, campaign: invalid_attributes
        campaign.reload
        expect(campaign.name).to eq name
      end
      it 're-renders the edit template' do
        expect(patch :update, id: campaign, campaign: invalid_attributes).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    before { campaign }
    it('deletes the campaign') { expect { delete :destroy, id: campaign }.to change(Campaign, :count).by(-1) }
    it('redirects to campaigns#index') { expect(delete :destroy, id: campaign).to redirect_to admin_campaigns_path }
    context 'when there are active offers' do
      before do
        create :campaign_offer, campaign: campaign,
          offer: create(:offer, start: Time.zone.yesterday, finish: Time.zone.tomorrow)
      end
      it('does not delete the campaign') { expect { delete :destroy, id: campaign }.to change(Campaign, :count).by(0) }
      it 'reports an error' do
        delete :destroy, id: campaign
        expect(flash[:error]).to include ['There are currently active offers on this campaign.']
      end
    end
  end

  describe 'POST #batch_action' do
    let(:campaigns) { [create(:campaign), create(:campaign)] }
    before { campaigns }
    it 'deletes the campaigns' do
      expect do
        post :batch_action,
          batch_action: 'destroy',
          collection_selection_toggle_all: 'on',
          collection_selection: campaigns
      end.to change(Campaign, :count).by(-2)
    end
    it 'redirects to campaigns#index' do
      post :batch_action,
        batch_action: 'destroy',
        collection_selection_toggle_all: 'on',
        collection_selection: campaigns
      expect(response).to redirect_to admin_campaigns_path
    end
  end
end
