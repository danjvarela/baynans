class User < ApplicationRecord
  before_validation :set_trading_status, on: :create

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :confirmable
  enum :user_type, {trader: 0, admin: 1}
  enum :trading_status, {pending: 0, approved: 1}, prefix: true

  private

  def set_trading_status
    self.trading_status = admin? ? :approved : :pending
  end
end
