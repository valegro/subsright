require 'rails_helper'

RSpec.feature 'Take an offer', type: :feature do
  given(:address) { "#{Faker::Address.street_address} #{Faker::Address.street_suffix} #{Faker::Address.city}" }
  given(:offer) { create(:offer, description: Faker::Lorem.sentences.join("\s")) }
  given(:price) { create(:price) }
  background { create(:offer_price, offer: offer, price: price) }

  context 'when not signed in' do
    background { visit offer_path(offer) }

    scenario('see customer detail form') { expect(page).to have_field 'purchase_customer_name' }

    scenario 'require customer name' do
      click_on 'Purchase'
      expect(page).to have_content "Name can't be blank"
    end

    context 'when customer name and email on file' do
      given(:customer) { create(:customer, email: Faker::Internet.email) }
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
      background do
        fill_in :purchase_customer_name, with: Faker::Name.name
        fill_in :purchase_customer_address, with: address
        fill_in :purchase_customer_postcode, with: Faker::Address.postcode
      end

      scenario('create new customer') { expect { click_on 'Purchase' }.to change(Customer, :count).by(1) }

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
    given(:user) { create(:user, confirmed_at: Time.zone.now) }
    background { login_as user }
    scenario 'require at least one customer'
  end

  context 'when an included product is out of stock' do
    scenario 'see out of stock warning' do
      create(:offer_product, offer: offer, product: create(:product, stock: 0))
      visit offer_path(offer)
      expect(page).to have_text 'out of stock'
    end
  end

  context 'when there are optional products' do
    let(:product1) { create(:product, stock: 2) }
    let(:product2) { create(:product, stock: 3) }

    scenario 'default to first optional product with most stock' do
      create(:offer_product, offer: offer, product: product1, optional: true)
      create(:offer_product, offer: offer, product: product2, optional: true)
      visit offer_path(offer)
      expect(page).to have_checked_field "purchase_customer_product_id_#{product2.id}"
    end

    context 'when an optional product is out of stock' do
      scenario 'ensure product is not offered' do
        product = create(:product, stock: 0)
        create(:offer_product, offer: offer, product: product, optional: true)
        visit offer_path(offer)
        expect(page).not_to have_field "purchase_customer_product_id_#{product.id}"
      end
    end
  end

  scenario 'create a pending purchase' do
    visit offer_path(offer)
    fill_in :purchase_customer_name, with: Faker::Name.name
    fill_in :purchase_customer_address, with: address
    fill_in :purchase_customer_postcode, with: Faker::Address.postcode
    expect { click_on 'Purchase' }.to change(Purchase, :count).by(1)
  end

  context 'when there are publications' do
    given(:publication) { create(:publication) }
    given(:offer_publication) { create(:offer_publication, offer: offer, publication: publication) }
    background do
      offer_publication
      visit offer_path(offer)
      fill_in :purchase_customer_name, with: Faker::Name.name
      fill_in :purchase_customer_address, with: address
      fill_in :purchase_customer_postcode, with: Faker::Address.postcode
    end
    scenario('create payments') { expect { click_on 'Purchase' }.to change(Payment, :count).by(1) }
    scenario('create new subscriptions') { expect { click_on 'Purchase' }.to change(Subscription, :count).by(1) }
    scenario 'set trial period on new subscriptions' do
      offer.trial_period = Faker::Number.number(2)
      offer.save!
      click_on 'Purchase'
      expect(Subscription.last.expiry).to eq Time.zone.today + offer.trial_period
    end
  end

  context 'when there are products' do
    scenario 'create product orders' do
      create(:offer_product, offer: offer, product: create(:product))
      visit offer_path(offer)
      fill_in :purchase_customer_name, with: Faker::Name.name
      fill_in :purchase_customer_address, with: address
      fill_in :purchase_customer_postcode, with: Faker::Address.postcode
      expect { click_on 'Purchase' }.to change(ProductOrder, :count).by(1)
    end
  end
end
