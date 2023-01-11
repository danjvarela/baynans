FactoryBot.define do
  symbol = Faker::Finance.ticker
  factory :stock do
    symbol { symbol }
    company_name { symbol }
  end
end
