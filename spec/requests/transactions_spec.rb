require 'rails_helper'

RSpec.describe 'Transactions', type: :request do
  let(:user) do
    user = build :user
    user.skip_confirmation!
    user.save!
    user.trading_status_approved!
    user
  end

  before :each do
    sign_in user
  end

  let(:stock) { create :stock }

  describe 'GET /transactions' do
    it 'should return http success' do
      get transactions_path
      expect(response).to be_successful
    end

    it 'should render transaction history page' do
      get transactions_path
      expect(response).to render_template :index
    end
  end

  describe 'GET /stocks/:stock_id/transactions/new' do
    it 'should return http success' do
      get new_stock_transaction_path(stock)
      expect(response).to be_successful
    end

    it 'should render the trading page' do
      get new_stock_transaction_path(stock)
      expect(response).to render_template :new
    end
  end

  describe 'POST /stocks/:stock_id/transactions' do
    context 'with valid params' do
      let(:valid_params) { { amount: 1.0, transaction_type: 'buy' } }

      it 'should redirect to /stocks/:stock_id/transactions/new' do
        post stock_transactions_path(stock), params: { transaction: valid_params }
        expect(response).to redirect_to new_stock_transaction_path(stock)
      end

      it 'should create a new transaction' do
        expect { post stock_transactions_path(stock), params: { transaction: valid_params } }.to change {
                                                                                                   Transaction.count
                                                                                                 }.by(1)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { amount: nil, transaction_type: 'buy' } }

      it 'should render new transactions page' do
        post stock_transactions_path(stock), params: { transaction: invalid_params }
        expect(response).to render_template :new
      end
    end
  end
end
