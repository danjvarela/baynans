class Stock < ApplicationRecord
  has_many :transactions, dependent: :destroy
  has_many :users, through: :transactions
  validates :symbol, presence: true, uniqueness: { case_sensitive: false }
  validates :company_name, presence: true
end
