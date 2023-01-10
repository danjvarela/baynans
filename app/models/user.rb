class User < ApplicationRecord
  has_many :transactions, dependent: :destroy
  has_many :stocks, through: :transactions
  before_validation :set_trading_status, on: :create

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  enum :user_type, { trader: 0, admin: 1 }
  enum :trading_status, { pending: 0, approved: 1 }, prefix: true

  def transactions_by_stock
    transactions.group_by { |transaction| transaction.stock.symbol }
  end

  def stock_units(symbol)
    transactions_by_stock[symbol]&.sum(&:units) || 0
  end

  def portfolio_companies
    stock_symbols = stocks.pluck(:symbol).uniq
    batch_companies = stock_symbols.in_groups_of(10, false).map do |symbols|
      Iex.client.get('/stock/market/batch',
                     { token: ENV['iex_publishable_token'], symbols: symbols.map(&:downcase).join(','),
                       types: [:company] })
    end

    stock_symbols.index_with do |symbol|
      batch_companies[0][symbol]['company']
    end
  end

  private

  def set_trading_status
    self.trading_status = admin? ? :approved : :pending
  end
end
