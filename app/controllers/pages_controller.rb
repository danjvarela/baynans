class PagesController < ApplicationController
  def home
    # list of active stocks
    @stock_market_list = Iex.most_active_stocks
  end
end
