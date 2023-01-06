class PagesController < ApplicationController
  def home
    client = Iex.client
    # list of active stocks
    @stock_market_list = client.stock_market_list(:mostactive)
  end
end
