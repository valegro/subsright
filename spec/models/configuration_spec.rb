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
  it do
    configuration.provider_logo_file_name = 'test'
    expect(configuration).not_to allow_value('invalid').for(:provider_logo_content_type)
  end
  it { expect(configuration).to be_valid }
  it 'returns the provider logo as an attachment' do
    expect(Configuration.provider_logo).to be_a Paperclip::Attachment
  end
  it 'stores the provider logo filename from an attachment' do
    Configuration.provider_logo = File.new Rails.root.join( *%w(app assets images subscriptus-logo.png) )
    expect(Configuration.provider_logo_file_name).to eq 'subscriptus-logo.png'
  end
end
