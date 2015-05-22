require 'rails_helper'

RSpec.describe Configuration, type: :model do
  let(:configuration) { build(:configuration) }
  it { expect(configuration).to have_db_column(:key).of_type(:string).with_options(null: false) }
  it { expect(configuration).to have_db_column(:value).of_type(:text) }
  it { expect(configuration).to have_db_column(:form_type).of_type(:string).with_options(null: false) }
  it { expect(configuration).to have_db_column(:form_collection_command).of_type(:string) }
  it { expect(configuration).to have_db_index(:key).unique }
  it { expect(configuration).to serialize(:value) }
  it { expect(configuration).to validate_presence_of :key }
  it { expect(configuration).to validate_uniqueness_of :key }
  it { expect(configuration).to validate_presence_of :form_type }
  it { expect(configuration).to be_valid }
end
