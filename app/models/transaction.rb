class Transaction < ApplicationRecord
  before_validation :calculate_units
  belongs_to :user
  belongs_to :stock
  validate :check_user_trading_status

  enum :transaction_type, { buy: 0, sell: 1 }

  private

  def check_user_trading_status
    return if user.trading_status_approved?

    errors.add(:user, 'must be approved')
  end

  def calculate_units
    self.units = self.amount / stock_price
  end
end
