class TransactionsController < ApplicationController
  before_action :initialize_stock, except: [:index]
  before_action :check_trading_status, only: [:create]
  def new
    @transaction = Transaction.new(stock: @stock, user: current_user, stock_price: @stock_quote.latest_price)
  end

  def create
    @transaction = Transaction.new transaction_params

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

  def initialize_stock
    @stock = Stock.find(params[:stock_id])
    @stock_quote = Iex.client.quote(@stock.symbol)
  end

  def check_trading_status
    return unless current_user.trading_status_pending?

    redirect_to(new_stock_transaction_path(@stock),
                alert: 'Your trading status is pending, please wait for admin approval')
  end

  def transaction_params
    transaction_form = params.require(:transaction)
    stock_price = @stock_quote.latest_price
    transaction_type = transaction_form[:transaction_type].to_sym
    amount = transaction_form[:amount].to_f * (transaction_type == :sell ? -1 : 1)
    { stock: @stock, user: current_user, stock_price:, transaction_type:, amount:, units: amount / stock_price }
  end
end
