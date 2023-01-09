class TransactionsController < ApplicationController
  before_action :get_stock
  def new
    @transaction = Transaction.new(stock: @stock, user: current_user, stock_price: @stock_quote.latest_price)
  end

  def create
    stock_price = @stock_quote.latest_price
    transaction_type = get_transaction[:transaction_type].to_sym
    amount = get_transaction[:amount].to_f * (transaction_type == :sell ? -1 : 1)
    transaction_attributes = {
      stock: @stock,
      user: current_user,
      stock_price: stock_price,
      transaction_type: transaction_type,
      amount: amount,
      units: amount / stock_price
    }
    @transaction = Transaction.new transaction_attributes

    if @transaction.save
      redirect_to new_stock_transaction_path(@stock), notice: "Succesfully placed order!"
    else
      flash.now[:alert] = "Something went wrong, please try again!"
      render :new
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


