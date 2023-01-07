class TransactionsController < ApplicationController
  before_action :get_stock
  def new
    @transaction = Transaction.new(stock: @stock, user: current_user, stock_price: @stock_quote.latest_price)
  end

  def create
    @transaction = Transaction.new(stock: @stock, user: current_user, stock_price: @stock_quote.latest_price, transaction_type: get_transaction[:transaction_type].to_sym, amount: get_transaction[:amount].to_f)
    if @transaction.save
      redirect_to new_stock_transaction_path(@stock), notice: "Succesfully placed order!"
    else
      redirect_to new_stock_transaction_path(@stock), alert: "Something went wrong, please try again!"
    end
  end

  private

  def get_transaction
    params.require(:transaction)
  end

  def get_stock
    @stock = Stock.find(params[:stock_id])
    @stock_quote = Iex.client.quote(@stock.symbol)
  end
end