require 'rails_helper'

RSpec.describe CampaignsController, type: :controller do
  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns @campaigns in order of finish' do
      campaign1 = create(:campaign, finish: Time.zone.today + 2.days)
      campaign2 = create(:campaign, finish: Time.zone.today + 1.day)
      get :index
      expect(assigns(:campaigns)).to eq [campaign2, campaign1]
    end
    it('renders the index template') { expect(get :index).to render_template('index') }
  end

  describe 'GET #show' do
    let(:campaign) { create(:campaign) }
    it('responds successfully') { expect(get :show, id: campaign).to be_success }
    it 'assigns the requested campaign to @campaign' do
      get :show, id: campaign
      expect(assigns(:campaign)).to eq campaign
    end
    it('renders the show template') { expect(get :show, id: campaign).to render_template('show') }
  end
end
