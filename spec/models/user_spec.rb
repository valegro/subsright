require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  it { expect(user).to have_db_column(:name).of_type(:string).with_options(null: false) }
  it { expect(user).to have_db_column(:currency).of_type(:string) }
  it { expect(user).to have_db_column(:email).of_type(:string).with_options(null: false) }
  it { expect(user).to have_db_column(:encrypted_password).of_type(:string).with_options(null: false) }
  it { expect(user).to have_db_column(:reset_password_token).of_type(:string) }
  it { expect(user).to have_db_column(:reset_password_sent_at).of_type(:datetime) }
  it { expect(user).to have_db_column(:remember_created_at).of_type(:datetime) }
  it { expect(user).to have_db_column(:sign_in_count).of_type(:integer).with_options(default: 0, null: false) }
  it { expect(user).to have_db_column(:current_sign_in_at).of_type(:datetime) }
  it { expect(user).to have_db_column(:last_sign_in_at).of_type(:datetime) }
  it { expect(user).to have_db_column(:current_sign_in_ip).of_type(:inet) }
  it { expect(user).to have_db_column(:last_sign_in_ip).of_type(:inet) }
  it { expect(user).to have_db_column(:confirmation_token).of_type(:string) }
  it { expect(user).to have_db_column(:confirmed_at).of_type(:datetime) }
  it { expect(user).to have_db_column(:confirmation_sent_at).of_type(:datetime) }
  it { expect(user).to have_db_column(:unconfirmed_email).of_type(:string) }
  it { expect(user).to have_db_column(:failed_attempts).of_type(:integer).with_options(default: 0, null: false) }
  it { expect(user).to have_db_column(:unlock_token).of_type(:string) }
  it { expect(user).to have_db_column(:locked_at).of_type(:datetime) }
  it { expect(user).to have_db_index(:email).unique }
  it { expect(user).to have_db_index(:reset_password_token).unique }
  it { expect(user).to have_db_index(:confirmation_token).unique }
  it { expect(user).to have_db_index(:unlock_token).unique }
  it { expect(user).to have_many(:customers) }
  it { expect(user).to accept_nested_attributes_for(:customers) }
  it { expect(user).to validate_presence_of :name }
  it { expect(user).to validate_presence_of :email }
  it { expect(user).to validate_uniqueness_of :email }
  it('does not allow an invalid email address') { expect(user).not_to allow_value('test@test').for(:email) }
  it 'translates currency names' do
    user.currency = 'BTC'
    expect(user.currency_name).to eq 'Bitcoin (BTC)'
  end
  it('supports no currency') { expect(user.currency_name).to be nil }
end
