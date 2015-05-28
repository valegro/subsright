require 'rails_helper'

RSpec.feature 'View publications', type: :feature do
  scenario 'get a link to each publication' do
    publication1 = create(:publication)
    publication2 = create(:publication)
    visit publications_path
    expect(page).to have_link publication1.name, href: publication_path(publication1)
    expect(page).to have_link publication2.name, href: publication_path(publication2)
  end
end
