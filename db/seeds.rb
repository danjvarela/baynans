# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# User.create email: "trader1@example", password: "password"
# User.create email: "admin1@example", password: "password", user_type: :admin

admin = User.new email: 'admin@example.com', password: 'qwerty', user_type: :admin
admin.skip_confirmation!
admin.save! unless User.find_by email: admin.email

Iex.most_active_stocks.each do |stock|
  Stock.create symbol: stock['symbol'], company_name: stock['company_name'] unless Stock.find_by symbol: stock['symbol']
end

stocks = Stock.all

10.times do |n|
  user = User.new email: "user#{n}@example.com", password: 'qwerty'
  user.skip_confirmation!
  user.save unless User.find_by email: user.email
  user.trading_status_approved!

  stock = stocks.sample
  quote = Iex.client.quote stock.symbol
  stock_price = quote['latest_price']
  amount = stock_price
  units = amount / stock_price
  Transaction.create(user:, stock:, amount:, transaction_type: :buy, stock_price:, units:)
  Transaction.create(user:, stock:, amount:, transaction_type: :sell, stock_price:, units:)
end
