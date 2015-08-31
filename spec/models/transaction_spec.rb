require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:transaction) { create :transaction }
  it { expect(transaction).to have_db_column(:amount_cents).of_type(:integer) }
  it { expect(transaction).to have_db_column(:message).of_type(:string).with_options(null: false) }
  it { expect(transaction).to have_db_index :message }
  it { expect(transaction).to belong_to :purchase }
  it { expect(transaction).to validate_presence_of(:message) }
  it 'validates uniqueness of message' do
    create :transaction, amount_cents: 1, message: 'test'
    transaction.amount_cents = 2
    expect(transaction).not_to allow_value('test').for(:message).with_message(:taken)
  end
  it 'formats amounts' do
    transaction.amount = '123:456'
    expect(transaction.amount).to eq '$1,234.56'
  end
  it('without amount') { expect(transaction.to_s).to eq "#{I18n.l transaction.created_at, format: :long} MyString" }
  it 'with amount' do
    transaction.amount_cents = 123
    expect(transaction.to_s).to eq "#{I18n.l transaction.created_at, format: :long} MyString $1.23"
  end
end
