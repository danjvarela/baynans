class PagesController < ApplicationController
  def home
    # list of active stocks
    @stock_market_list = Iex.most_active_stocks
    @stock_market_list.each do |stock|
      Stock.create(company_name: stock["company_name"], symbol: stock["symbol"]) unless Stock.find_by(symbol: stock["symbol"])
    end
    @stocks = Stock.all
  end
end
