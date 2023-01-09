class TransactionsController < ApplicationController
  before_action :get_stock, except: [:index]
  before_action :check_trading_status, only: [:create]
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
      stock_price:,
      transaction_type:,
      amount:,
      units: amount / stock_price
    }
    @transaction = Transaction.new transaction_attributes

    if @transaction.save
      redirect_to new_stock_transaction_path(@stock), notice: 'Succesfully placed order!'
    else
      flash.now[:alert] = 'Something went wrong, please try again!'
      render :new
    end
  end

  def index
    @transactions = current_user.transactions
  end

  private

  def get_transaction
    params.require(:transaction)
  end

  def get_stock
    @stock = Stock.find(params[:stock_id])
    @stock_quote = Iex.client.quote(@stock.symbol)
  end

  def check_trading_status
    redirect_to(new_stock_transaction_path(@stock), alert: "Your trading status is pending, please wait for admin approval") if current_user.trading_status_pending?
  end
end
