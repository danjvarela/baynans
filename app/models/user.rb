class User < ApplicationRecord
  has_many :transactions
  has_many :stocks, through: :transactions
  before_validation :set_trading_status, on: :create

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  enum :user_type, { trader: 0, admin: 1 }
  enum :trading_status, { pending: 0, approved: 1 }, prefix: true

  def units_owned
    transactions.each_with_object({}) do |transaction, accumulator|
      if !accumulator[transaction.stock.symbol]
        accumulator[transaction.stock.symbol] = transaction.units
      else
        accumulator[transaction.stock.symbol] += transaction.units
      end
    end
  end

  private

  def set_trading_status
    self.trading_status = admin? ? :approved : :pending
  end
end
