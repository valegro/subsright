require 'rails_helper'

RSpec.feature 'View products', type: :feature do
  scenario 'get a link to each product' do
    product1 = create(:product)
    product2 = create(:product)
    visit products_path
    expect(page).to have_link product1.name, href: product_path(product1)
    expect(page).to have_link product2.name, href: product_path(product2)
  end
end
