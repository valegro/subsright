require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns @campaigns in order of finish where there is at least one offer' do
      c1 = create(:campaign, finish: Time.zone.today + 2.days)
      create(:campaign)
      c2 = create(:campaign, finish: Time.zone.today + 1.day)
      o = create(:offer)
      create(:campaign_offer, campaign: c1, offer: o)
      create(:campaign_offer, campaign: c2, offer: o)
      get :index
      expect(assigns(:campaigns)).to eq [c2, c1]
    end
    it('renders the index template') { expect(get :index).to render_template('index') }
  end
end
