require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { build(:product) }
  it { expect(product).to have_db_column(:name).of_type(:string).with_options(null: false) }
  it { expect(product).to have_db_column(:stock).of_type(:integer) }
  it { expect(product).to have_db_column(:image_file_name).of_type(:string) }
  it { expect(product).to have_db_column(:description).of_type(:text) }
  it { expect(product).to have_db_index(:name).unique }
  it { expect(product).to have_many(:offer_products) }
  it { expect(product).to accept_nested_attributes_for(:offer_products) }
  it { expect(product).to have_many(:offers).through(:offer_products) }
  it { expect(product).to accept_nested_attributes_for(:offers) }
  it { expect(product).to have_many(:product_orders) }
  it { expect(product).to validate_presence_of(:name) }
  it { expect(product).to validate_uniqueness_of(:name) }
  it { expect(product).not_to allow_value('invalid').for(:image_content_type) }
  it { expect(product).to be_valid }
end
