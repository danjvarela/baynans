# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# User.create email: "trader1@example", password: "password"
# User.create email: "admin1@example", password: "password", user_type: :admin

admin = User.new(email: "admin@example.com", password: "qwerty", user_type: :admin)
admin.skip_confirmation!
admin.save!

client = Iex.client

10.times do |n|
  user = User.new(email: "user#{n}@example.com", password: "qwerty")
  user.skip_confirmation!
  user.save!
  apple = client.company("AAPL")
  stock = Stock.create(company_name: apple.company_name, symbol: apple.symbol)
  user.stocks << stock
end

Stock.create(symbol: "AAPL", company_name: "Apple Inc.")
