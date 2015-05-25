require 'rails_helper'
include Devise::TestHelpers

RSpec.describe Admin::PublicationsController, type: :controller do
  before { sign_in AdminUser.first }
  let(:publication) { create(:publication) }

  describe 'GET #index' do
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns @publications' do
      get :index
      expect(assigns(:publications)).to eq [publication]
    end
    it('renders the index template') { expect(get :index).to render_template('index') }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new publication' do
        expect { post :create, publication: attributes_for(:publication) }.to change(Publication, :count).by(1)
      end
      it 'redirects to the new publication' do
        post :create, publication: attributes_for(:publication)
        expect(response).to redirect_to admin_publication_path(Publication.last)
      end
    end
    context 'with invalid attributes' do
      it 'does not save the new publication' do
        expect { post :create, publication: nil }.not_to change(Publication, :count)
      end
      it('re-renders the new method') { expect(post :create, publication: nil).to render_template('new') }
    end
  end

  describe 'GET #new' do
    it('responds successfully') { expect(get :new).to be_success }
    it('renders the new template') { expect(get :new).to render_template('new') }
  end

  describe 'GET #edit' do
    it('responds successfully') { expect(get :edit, id: publication).to be_success }
    it('renders the edit template') { expect(get :edit, id: publication).to render_template('edit') }
  end

  describe 'GET #show' do
    it('responds successfully') { expect(get :show, id: publication).to be_success }
    it 'assigns the requested publication to @publication' do
      get :show, id: publication
      expect(assigns(:publication)).to eq publication
    end
    it('renders the show template') { expect(get :show, id: publication).to render_template('show') }
  end

  describe 'PATCH #update' do
    before { publication }
    context 'with valid attributes' do
      it 'locates the requested publication' do
        patch :update, id: publication, publication: attributes_for(:publication)
        expect(assigns(:publication)).to eq publication
      end
      it "changes the publication's attributes" do
        new_attributes = attributes_for(:publication)
        patch :update, id: publication, publication: new_attributes
        publication.reload
        expect(publication.name).to eq new_attributes[:name]
      end
      it 'redirects to the updated publication' do
        patch :update, id: publication, publication: attributes_for(:publication)
        expect(response).to redirect_to admin_publication_path(publication)
      end
    end
    context 'with invalid attributes' do
      it 'locates the requested publication' do
        patch :update, id: publication, publication: nil
        expect(assigns(:publication)).to eq publication
      end
      it "does not change the publication's attributes" do
        name = publication.name
        patch :update, id: publication, publication: nil
        publication.reload
        expect(publication.name).to eq name
      end
      it 'redirects back to the publication' do
        patch :update, id: publication, publication: nil
        expect(response).to redirect_to admin_publication_path(publication)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { publication }
    it('deletes the publication') { expect { delete :destroy, id: publication }.to change(Publication, :count).by(-1) }
    it('redirects to publications#index') do
      expect(delete :destroy, id: publication).to redirect_to admin_publications_path
    end
  end

  describe 'POST #batch_action' do
    let(:publications) { [create(:publication), create(:publication)] }
    before { publications }
    it('deletes the publications') do
      expect do
        post :batch_action,
          batch_action: 'destroy',
          collection_selection_toggle_all: 'on',
          collection_selection: publications
      end.to change(Publication, :count).by(-2)
    end
    it('redirects to publications#index') do
      post :batch_action,
        batch_action: 'destroy',
        collection_selection_toggle_all: 'on',
        collection_selection: publications
      expect(response).to redirect_to admin_publications_path
    end
  end
end
