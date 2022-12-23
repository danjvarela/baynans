class AdminMailer < ApplicationMailer
  def approve_user_email
    @user = params[:user]
    mail to: @user.email, subject: "Request to Trade Approved"
  end
end
