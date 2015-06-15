require 'rails_helper'

RSpec.feature 'Take an offer', type: :feature do
  given(:offer) { create(:offer, description: Faker::Lorem.sentences.join("\s")) }
  given(:price) { create(:price) }
  background { create(:offer_price, offer: offer, price: price) }

  context 'when not signed in' do
    given(:address) { "#{Faker::Address.street_address} #{Faker::Address.street_suffix} #{Faker::Address.city}" }
    background { visit offer_path(offer) }
    scenario('see customer detail form') { expect(page).to have_css 'li#purchase_customer_name_input' }

    scenario 'require customer name' do
      click_on 'Purchase'
      expect(page).to have_content "Name can't be blank"
    end

    context 'when customer name and email on file' do
      given(:customer) { create(:customer, email: Faker::Internet.email) }
      scenario 'autofill customer details'
      scenario 'update existing customer details' do
        fill_in :purchase_customer_name, with: customer.name
        fill_in :purchase_customer_email, with: customer.email
        fill_in :purchase_customer_address, with: address
        fill_in :purchase_customer_postcode, with: Faker::Address.postcode
        click_on 'Purchase'
        expect(Customer.find(customer.id).address).to eq address
      end
    end

    context 'when customer is new' do
      given(:customer) { build(:customer, address: address, postcode: Faker::Address.postcode) }
      background do
        fill_in :purchase_customer_name, with: customer.name
        fill_in :purchase_customer_address, with: address
        fill_in :purchase_customer_postcode, with: Faker::Address.postcode
      end

      scenario 'create new customer' do
        expect { click_on 'Purchase' }.to change(Customer, :count).by(1)
      end

      context 'when email matches existing user' do
        given(:user) { create(:user) }
        scenario 'associate customer with existing user' do
          fill_in :purchase_customer_email, with: user.email
          click_on 'Purchase'
          expect(Customer.last.user).to eq user
        end
      end

      context 'when email not on file' do
        scenario 'create new user' do
          fill_in :purchase_customer_email, with: Faker::Internet.email
          expect { click_on 'Purchase' }.to change(User, :count).by(1)
        end
      end
    end
  end

  context 'when signed in' do
    context 'when there are no associated customers' do
      scenario 'see customer detail form'
      scenario 'require customer name'
    end
    context 'when there are multiple associated customers' do
      scenario 'see checkboxes for associated customers'
    end
    scenario 'see option to create new customer details'
    scenario 'require at least one customer'
  end
  context 'when an included product is out of stock' do
    scenario 'see out of stock warning'
  end
  context 'when there are optional products' do
    scenario 'default to first optional product with most stock'
    context 'when an optional product is out of stock' do
      scenario 'see out of stock warning'
      scenario 'see that selection is disabled'
    end
  end
  scenario 'create a pending transaction'
  context 'when there are publications' do
    scenario 'create customer publications'
  end
end
