class PagesController < ApplicationController
  def home
    # list of active stocks
    @stock_market_list = Iex.most_active_stocks
    @stock_market_list.each do |stock|
      unless Stock.find_by(symbol: stock['symbol'])
        Stock.create(company_name: stock['company_name'],
                     symbol: stock['symbol'])
      end
    end
    @stocks = Stock.all
  end
end
