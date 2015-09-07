require 'rails_helper'

RSpec.describe PurchasesWithTotal, type: :model do
  let(:purchase) { create :purchase }
  let(:purchase_with_total) { PurchasesWithTotal.find(purchase.id) }

  context 'without initial amount' do
    before { purchase.update! amount_cents: 123 }
    context 'without monthly payments' do
      it { expect(purchase_with_total.total_cents).to eq 123 }
    end
    context 'with monthly payments' do
      before { purchase.update! monthly_payments: 4 }
      it { expect(purchase_with_total.total_cents).to eq 123 * 4 }
    end
  end

  context 'with initial amount' do
    before { purchase.update! initial_amount_cents: 123, amount_cents: 456 }
    context 'without monthly payments' do
      it { expect(purchase_with_total.total_cents).to eq 123 + 456 }
    end
    context 'with monthly payments' do
      before { purchase.update! monthly_payments: 7 }
      it { expect(purchase_with_total.total_cents).to eq 123 + 456 * 7 }
    end
  end

  it 'formats amount' do
    purchase.amount_cents = '123456'
    purchase.save!
    expect(PurchasesWithTotal.find(purchase.id).amount).to eq '$1,234.56'
  end
  it 'formats balance' do
    purchase.initial_amount_cents = '1234'
    purchase.amount_cents = '5678'
    purchase.paid_cents = '123'
    purchase.save!
    expect(PurchasesWithTotal.find(purchase.id).balance).to eq '$67.89'
  end
  it 'formats paid' do
    purchase.paid_cents = '123456'
    purchase.save!
    expect(PurchasesWithTotal.find(purchase.id).paid).to eq '$1,234.56'
  end
  it 'formats total' do
    purchase.initial_amount_cents = '1234'
    purchase.amount_cents = '5678'
    purchase.save!
    expect(PurchasesWithTotal.find(purchase.id).total).to eq '$69.12'
  end
end
