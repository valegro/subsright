require 'rails_helper'
require 'faker'

RSpec.feature 'Show a publication', type: :feature do
  given(:publication) { create(:publication, description: Faker::Lorem.sentences.join("\s")) }
  scenario 'see publication image with link to website' do
    visit publication_path(publication)
    expect(page).to have_css 'a img'
    expect(page).to have_link publication.name, href: publication.website
  end
  scenario 'see publication name and description' do
    visit publication_path(publication)
    expect(page).to have_text publication.name
    expect(page).to have_text publication.description
  end

  context 'when there are no offers' do
    scenario 'see "Not presently available"' do
      visit publication_path(publication)
      expect(page).to have_text 'Not presently available'
    end
  end

  context 'when there are offers' do
    given(:offer1) { create(:offer) }
    given(:offer2) { create(:offer) }
    background do
      create(:offer_publication, publication: publication, offer: offer1)
      create(:offer_publication, publication: publication, offer: offer2)
      visit publication_path(publication)
    end
    scenario 'get a link to each offer' do
      expect(page).to have_link offer1.name, href: offer_path(offer1)
      expect(page).to have_link offer2.name, href: offer_path(offer2)
    end
  end
end
