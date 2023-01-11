require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:user) do
    user = build :user
    user.skip_confirmation!
    user.save!
    user.trading_status_approved!
    user
  end
  let(:stock) { create :stock }

  describe 'Amount' do
    it 'should be present' do
      transaction = build :transaction, amount: nil
      expect(transaction.save).to be false
    end

    it 'should be greater than 0' do
      transaction = build :transaction, amount: -1
      expect(transaction.save).to be false
    end

    it 'should be negative if sell' do
      create :transaction, stock:
      transaction = create(:transaction, transaction_type: :sell, user:, stock:)
      expect(transaction.amount).to be < 0
    end

    it 'should be less than or equal to what the user owns' do
      transaction = build(:transaction, transaction_type: :sell, user:, stock:)
      expect(transaction.save).to be false
    end
  end

  describe 'Stock price' do
    it 'should be present' do
      transaction = build :transaction, stock_price: nil
      expect(transaction.save).to be false
    end

    it 'should be greater than 0' do
      transaction = build :transaction, stock_price: -1
      expect(transaction.save).to be false
    end
  end

  describe 'User' do
    it 'should be approved' do
      user = create(:user, trading_status: :pending)
      transaction = build(:transaction, user:)
      expect(transaction.save).to be false
    end
  end

  describe 'Transaction type ' do
    it 'should be present' do
      transaction = build(:transaction, transaction_type: nil, user:)
      expect(transaction.save).to be false
    end
  end
end
