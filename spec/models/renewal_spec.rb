require 'rails_helper'

RSpec.describe Renewal, type: :model do
  let(:renewal) { build(:renewal) }
  it { expect(renewal).to belong_to(:purchase) }
  it { expect(renewal).to belong_to(:subscription) }
  it { expect(renewal).to have_db_column(:price_name).of_type(:string).with_options(null: false) }
  it { expect(renewal).to have_db_column(:discount_name).of_type(:string) }
  it { expect(renewal).to have_db_index([:subscription_id, :purchase_id]).unique }
  it { expect(renewal).to validate_presence_of(:purchase) }
  it { expect(renewal).to validate_presence_of(:subscription) }
  it { expect(renewal).to validate_presence_of(:price_name) }
  it { expect(renewal).to be_valid }
  it 'formats renewals' do
    subscription = create(:subscription, publication: create(:publication))
    renewal = build(:renewal, subscription: subscription)
    expect(renewal.to_s).to eq "#{renewal.price_name}: #{subscription.publication.name}"
  end
end
