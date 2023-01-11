FactoryBot.define do
  factory :transaction do
    user { association :user }
    stock { association :stock }
    amount { 1.5 }
    transaction_type { 0 }
    stock_price { 1 }
  end
end
