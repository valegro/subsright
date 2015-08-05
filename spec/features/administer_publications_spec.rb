require 'rails_helper'

RSpec.feature 'Administer publication', type: :feature do
  scenario 'require login' do
    visit admin_publications_path
    expect(current_path).to eq new_admin_user_session_path
  end

  context 'when logged in' do
    given(:admin_user) { create :admin_user, confirmed_at: Time.zone.now }
    given(:publication) { create :publication }
    background do
      publication
      login_as admin_user, scope: :admin_user
    end

    context 'when showing index' do
      background { visit admin_publications_path }
      [ :name, :image, :website, :offers, :subscriptions, :created_at, :updated_at ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
      scenario('filter by name')                { expect(page).to have_field 'q_name' }
      scenario('filter by image update time')   { expect(page).to have_field 'q_image_updated_at_gteq' }
      scenario('filter by website')             { expect(page).to have_field 'q_website' }
      scenario('filter by offer')               { expect(page).to have_field 'q_offer_ids' }
      scenario('filter by subscriptions count') { expect(page).to have_field 'q_subscriptions_count' }
      scenario('filter by description')         { expect(page).to have_field 'q_description' }
      scenario('filter by creation time')       { expect(page).to have_field 'q_created_at_gteq' }
      scenario('filter by update time')         { expect(page).to have_field 'q_updated_at_gteq' }
      scenario 'shows publication thumbnails' do
        publication.update! image: File.new( Rails.root.join( *%w(app assets images subscriptus-logo.png) ) )
        visit admin_publications_path
        expect(page).to have_css 'img[alt="Subscriptus logo"]'
      end
    end

    context 'when viewing record' do
      background { visit admin_publication_path(publication) }
      [ :name, :image, :website, :offers, :subscriptions, :description, :created_at, :updated_at ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
      scenario 'shows the publication image' do
        publication.update! image: File.new( Rails.root.join( *%w(app assets images subscriptus-logo.png) ) )
        visit admin_publication_path(publication)
        expect(page).to have_css 'img[alt="Subscriptus logo"]'
      end
    end

    context 'when editing record' do
      background { visit edit_admin_publication_path(publication) }
      scenario { expect(page).to have_field 'publication_name' }
      scenario { expect(page).to have_field 'publication_image' }
      scenario { expect(page).to have_field 'publication_website' }
      scenario { expect(page).to have_field 'publication_description' }
    end
  end
end
