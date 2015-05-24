require 'rails_helper'

RSpec.describe Discount, type: :model do
  let(:discount) { build(:discount) }
  it { expect(discount).to have_db_column(:name).of_type(:string).with_options(null: false) }
  it { expect(discount).to have_db_column(:requestable).of_type(:boolean) }
  it { expect(discount).to have_db_index(:name).unique }
  it { expect(discount).to have_many(:discount_prices) }
  it { expect(discount).to have_many(:prices).through(:discount_prices) }
  it { expect(discount).to accept_nested_attributes_for(:prices) }
  it { expect(discount).to validate_presence_of(:name) }
  it { expect(discount).to validate_uniqueness_of(:name) }
  it { expect(discount).to be_valid }
end
