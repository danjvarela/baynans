class Stock < ApplicationRecord
  has_many :transactions, dependent: :destroy
  has_many :users, through: :transactions
end
