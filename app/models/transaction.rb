class Transaction < ApplicationRecord
  after_validation :negate_amount_if_sell
  after_validation :calculate_units
  belongs_to :user
  belongs_to :stock
  validate :check_user_trading_status
  validates :amount, numericality: { greater_than: 0 }, presence: true
  validate :sell_amount
  validates :stock_price, numericality: { greater_than: 0 }, presence: true

  enum :transaction_type, { buy: 0, sell: 1 }

  private

  def check_user_trading_status
    return if user.trading_status_approved?

    errors.add(:user, 'must be approved')
  end

  def negate_amount_if_sell
    self.amount *= -1 if sell?
  end

  def calculate_units
    self.units = self.amount / stock_price
  end

  def sell_amount
    return if buy?

    user_stock_units = user.stock_units(stock.symbol)
    return if amount <= user_stock_units * stock_price

    errors.add(:amount, "maximum value is #{user_stock_units * stock_price}")
  end
end
