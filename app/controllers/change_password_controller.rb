class ChangePasswordController < ApplicationController
  before_filter :authenticate?

  def index
    @user = User.find_by_user_name(session[:user])
    flash[:error], flash[:success] = nil
    if params[:form]
      if @user
        message = @user.change_password(params[:form][:oldPass], params[:form][:newPass1], params[:form][:newPass2])
        flash[message[:type]] = message[:text]
      else
        flash[:error] = "user not found"
      end
    end
  end

  private

  def authenticate?
    unless session[:user]
      session[:redirect_to] = change_password_path
      redirect_to session_user_path
    end
  end
end
