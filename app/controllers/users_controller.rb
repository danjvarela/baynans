class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_user, only: %i[show edit update destroy]
  before_action :get_user_type_options, only: %i[new create edit update]
  before_action :admin_only

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

  def show
  end

  def edit
  end

  def update
    if @user.update optional_password_params
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :user_type)
  end

  def admin_only
    if !current_user.admin?
      redirect_to root_path
    end
  end

  def optional_password_params
    custom_params = user_params
    custom_params[:password] = nil if user_params[:password].blank?
    custom_params[:password_confirmation] = nil if user_params[:password_confirmation].blank?
    custom_params
  end

  def get_user
    @user = User.find params[:id]
  end

  def get_user_type_options
    @user_type_options = User.user_types.keys.map { |type| [type.humanize, type] }
  end
end
