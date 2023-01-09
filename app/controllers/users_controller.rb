class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, except: [:portfolio]
  before_action :find_user, only: %i[show edit update destroy approve portfolio]
  before_action :user_type_options, only: %i[new create edit update]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update! optional_password_params
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!
    redirect_to root_path
  end

  def notifications
    @unconfirmed_users = User.trading_status_pending
  end

  def approve
    if @user.trading_status_approved!
      AdminMailer.with(user: @user).approve_user_email.deliver_later
      redirect_to admin_notifications_path, notice: "#{@user.email} has been approved for trading."
    else
      redirect_to admin_notifications_path, alert: 'Something went wrong.'
    end
  end

  def portfolio
    @stocks = @user.stocks
    # batch requests can only handle 10 symbols at a time so we split @stocks into groups of 10
    # and do a batch request for each group
    # => returns data in the shape of [{"AAPL" => {"company" => {...company_attributes_of_AAPL}}, "TSLA"=>{"company"=>{...company_attributes_of_TSLA}}, ...}]
    @batch_companies = @stocks.in_groups_of(10, false).map do |group|
      Iex.client.get('/stock/market/batch', {
                       token: ENV['iex_publishable_token'],
                       symbols: group.pluck(:symbol).map(&:downcase).join(','),
                       types: [:company]
                     })
    end

    # reshape the data so it becomes {"AAPL"=>{...company_attributes_of_AAPL}, "TSLA"=>{...company_attributes_of_TSLA}}
    @batch_companies = @batch_companies.first.keys.index_with do |symbol|
      @batch_companies.first[symbol]['company']
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :user_type, :trading_status)
  end

  def admin_only
    return if current_user.admin?

    redirect_to root_path
  end

  def optional_password_params
    custom_params = user_params
    custom_params[:password] = nil if user_params[:password].blank?
    custom_params[:password_confirmation] = nil if user_params[:password_confirmation].blank?
    custom_params
  end

  def find_user
    @user = User.find params[:id]
  end

  def user_type_options
    @user_type_options = User.user_types.keys.map { |type| [type.humanize, type] }
  end
end
