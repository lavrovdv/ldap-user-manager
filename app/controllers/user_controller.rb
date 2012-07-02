# encoding: UTF-8
class UserController < ApplicationController
  before_filter :authenticate?

  def index
    begin
      return @users = User.search_by_query(params[:q])    if params[:q]
      return @users = User.find_by_group(params[:group])  if params[:group]
      @users = params[:all] ?  User.find(:all) : User.find(:all, :limit => 20)
    rescue
      @users = []
    end
  end

  def view
    p "+++ #{params[:id]}"
    @user = User.find_by_uid(params[:id])
  end

  def edit
    @user = User.find_by_uid(params[:id])
    flash[:error], flash[:success] = nil

    if params[:form] and params[:form][:save] and @user
      @user.edit_by_params(params[:form])

      unless @user.valid_email and @user.valid_unique_email and @user.valid and @user.save
        flash[:error] = "Пользователь не сохранен,  данные введены неверно"
        @user = User.find_by_uid(@user.uid)
        return
      end
      @user = User.find_by_uid(params[:id])
      flash[:success] = "Пользователь успешно сохранен"
    end
  end

  def delete
    @user = User.find_by_uid(params[:id])
    @user.destroy unless @user.nil?
    @user = nil
    render 'user/view'
  end

  def create
    flash[:error] = nil

    if params[:form] and params[:form][:uid] and !params[:form][:uid].to_s.empty?

      @user = User.create_by_params(params[:form])

      if User.validate(@user) and @user.save
        redirect_to user_view_path + '/' + @user.uid
      else
        flash[:error] = "Пользователь не сохранен, данные введены неверно"
        redirect_to  user_new_path
      end
    else
      flash[:error] = "Пользователь не сохранен, данные введены неверно"
      redirect_to  user_new_path
    end
  end

  private

  def authenticate?
    unless session[:admin]
      session.clear
      session[:redirect_to] = root_path
      redirect_to session_admin_path
    end
  end

end
