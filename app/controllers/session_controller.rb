class SessionController < ApplicationController
  before_filter RubyCAS::Filter, :except => 'logout'
  before_filter :load_admins_list

  def load_admins_list
    @admins = YAML.load_file(Rails.root.join('config', 'admins.yml')).map{|el| el.downcase }
  end

  def admin
    if @admins.include?(session[:cas_user].downcase)
      admin = session[:cas_user]
      p '----session'
      require 'pp'
      pp session
      p "session size"
      session.clear
      session[:admin] = admin
      redirect_to session[:redirect_to] || root_path
    else
      @error_message = "You - #{session[:cas_user]} have no rights for using this application"
      render 'session/error'
    end
  end

  def user
    if User.find_by_user_name(session[:cas_user])
       user = session[:cas_user]
       session.clear
       session[:user] = user
       redirect_to change_password_path
    else
      @error_message = "Current user not found in Open LDAP"
      render 'session/error'
    end
  end

  def logout
    session.clear
    cas_base_url = Rails.configuration.rubycas.cas_base_url
    redirect_to "#{cas_base_url}/logout?service=#{cas_base_url}/cas/login?service=#{request.referer}"
  end

end
