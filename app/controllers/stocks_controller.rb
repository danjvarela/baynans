class StocksController < ApplicationController
  def trade
    @stock = Stock.find_by(symbol: get_stock[:symbol])
    @stock ||= Stock.create(symbol: get_stock[:symbol], company_name: get_stock[:company_name])

    @transaction = Transaction.new(user: current_user, stock: @stock, stock_price: get_stock[:latest_price])
  end

  def buy
    @transaction = Transaction.new(get_transaction)
    if @transaction.save
      redirect_to trade_stock_path,
                  notice: "Successfully bought #{@transaction.amount} of #{@transaction.stock.company_name}"
    else
      redirect_to trade_stock_path, alert: 'Something went wrong, please try again.'
    end
  end

  private

  def get_stock
    params.require(:stock).permit(:company_name, :symbol, :latest_price)
  end

  def get_transaction
    params.require(:transaction).permit(:stock_price, :user, :stock, :amount)
  end
end
