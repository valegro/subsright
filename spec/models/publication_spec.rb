require 'rails_helper'

RSpec.describe Publication, type: :model do
  let(:publication) { build(:publication) }
  it { expect(publication).to have_db_column(:name).of_type(:string).with_options(null: false) }
  it { expect(publication).to have_db_column(:website).of_type(:string).with_options(null: false) }
  it { expect(publication).to have_db_column(:api_key).of_type(:string).with_options(null: false) }
  it { expect(publication).to have_db_column(:image_file_name).of_type(:string) }
  it { expect(publication).to have_db_column(:description).of_type(:text) }
  it { expect(publication).to have_db_column(:subscriptions_count).of_type(:integer).with_options(null: false) }
  it { expect(publication).to have_db_index(:name).unique }
  it { expect(publication).to have_many(:offer_publications) }
  it { expect(publication).to accept_nested_attributes_for(:offer_publications) }
  it { expect(publication).to have_many(:offers).through(:offer_publications) }
  it { expect(publication).to accept_nested_attributes_for(:offers) }
  it { expect(publication).to have_many(:subscriptions) }
  it { expect(publication).to validate_presence_of(:name) }
  it { expect(publication).to validate_uniqueness_of(:name) }
  it { expect(publication).to validate_presence_of(:website) }
  it { expect(publication).not_to allow_value('invalid').for(:website) }
  it { expect(publication).not_to allow_value('invalid').for(:image_content_type) }
  it { expect(publication).to be_valid }
end
