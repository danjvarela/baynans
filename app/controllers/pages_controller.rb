class PagesController < ApplicationController
  def home
    @stocks = Stock.all

    client = Iex.client
    # list of active stocks
    @stock_market_list = client.stock_market_list(:mostactive)
  end
end
