require 'rails_helper'

RSpec.describe Payment, type: :model do
  let(:payment) { build(:payment) }
  it { expect(payment).to belong_to(:purchase) }
  it { expect(payment).to belong_to(:subscription) }
  it { expect(payment).to have_db_column(:price_name).of_type(:string).with_options(null: false) }
  it { expect(payment).to have_db_column(:discount_name).of_type(:string) }
  it { expect(payment).to have_db_index([:subscription_id, :purchase_id]).unique }
  it { expect(payment).to validate_presence_of(:purchase) }
  it { expect(payment).to validate_presence_of(:subscription) }
  it { expect(payment).to validate_presence_of(:price_name) }
  it { expect(payment).to be_valid }
end
