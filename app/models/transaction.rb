class Transaction < ApplicationRecord
  before_validation :calculate_units
  belongs_to :user
  belongs_to :stock
  validate :check_user_trading_status
  validates :amount, presence: true, numericality: { greater_than: 0 } 
  validate :sell_amount
  validates :stock_price, presence: true, numericality: { greater_than: 0 } 
  validates :units, presence: true

  enum :transaction_type, { buy: 0, sell: 1 }

  private

  def check_user_trading_status
    return if user.trading_status_approved?

    errors.add(:user, 'must be approved')
  end

  def calculate_units
    return if amount.blank? || stock_price.blank?

    amount = self.amount * (sell? ? -1 : 1)
    self.units = amount / stock_price
  end

  def sell_amount
    return if buy?
    return if stock_price.blank? || amount.blank?

    user_stock_units = user.stock_units(stock.symbol)
    return if amount <= user_stock_units * stock_price

    errors.add(:amount, "maximum value is #{user_stock_units * stock_price}")
  end
end
