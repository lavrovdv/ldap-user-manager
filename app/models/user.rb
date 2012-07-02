# encoding: utf-8
class User < ActiveLdap::Base
  ldap_mapping :dn_attribute => "uid",
               :prefix => "ou=People",
               :classes => %W(inetOrgPerson person organizationalPerson)

  def self.view_fields
    %w(uid givenName sn mail telephoneNumber objectClass userPassword l)
  end

  def self.new_fields
    %w(uid givenName sn mail telephoneNumber userPassword l)
  end

  def self.edit_fields
    %w(mail givenName sn telephoneNumber userPassword l)
  end

  def self.save_fields
    %w(mail cn givenName telephoneNumber sn userPassword l)
  end

  # Описание полей
  def self.pretty_field_name(name)
    names = {uid: "UID",
             cn: "cn",
             givenName: "Имя",
             telephoneNumber: "Телефон",
             mail: "Mail",
             sn: "Фамилия",
             objectClass: "Object class",
             userPassword: "Пароль",
             l: "Запретить доступ к приложению"}

    names[name.to_sym]
  end

  def self.application_list
    @application_list = Application.all.map{|app| app.name}
  end

  # Получаем хешь пароля из строки
  #
  def self.get_password_hash(pass)
    require 'digest/sha1'
    "{SHA}#{Base64.encode64(Digest::SHA1.hexdigest(pass).lines.to_a.pack('H*'))}"
  end

  def self.find_by_uid(uid)
    begin
      @user = uid ?  User.find(:first, :attribute => 'uid', :value => uid) : nil
    rescue
      @user = nil
    end
  end

  def self.find_by_user_name(user_name)
    begin
      @user = user_name ?  User.find(:first, :attribute => 'cn', :value => user_name) : nil
    rescue
      @user = nil
    end
  end

  def self.validate(user)
    user.valid and user.valid_email and user.valid_unique_email and user.valid_exist
  end

  def valid_exist
    if self.exists?
      p "User validation filed - User already exist"
      false
    else
      true
    end
  end

  def valid_email
    if /^(\S+)@([a-z0-9-]+)(\.)([a-z]{2,4})(\.?)([a-z]{0,4})+$/.match(self.mail)
      true
    else
      p "User validation filed - User mail -'#{self.mail}' invalid"
      false
    end
  end

  def valid_unique_email
    users = User.find(:all, :attribute=>'mail', :value=>self.mail)
    if !users.nil? and users.size > 1 and users[0].uid != self.uid
      p "User validation filed - User mail -'#{self.mail}' already exist"
      false
    else
      true
    end
  end

  def valid
    if self.valid?
      true
    else
      p "User validation filed - User model not valid, maybe some model attributes is empty"
      false
    end
  end

  def change_password(old_pass, new_pass1, new_pass2)

    return {:type => :error, :text => "Заполните все поля" }   unless old_pass && new_pass1 && new_pass2
    return {:type => :error, :text => "Неверный пароль" }      if User.get_password_hash(old_pass) != self.userPassword
    return {:type => :error, :text => "Пароли не совпадают" }  if new_pass1 != new_pass2

    self.userPassword = User.get_password_hash(new_pass2)
    self.save ? {:type => :success, :text => "Пароль успешно изменен"} : {:type => :error, :text => "Не удалось изменить пароль"}

  end

  def self.search_by_query(query)
    search_string = "(|" +  %w(cn givenName telephoneNumber mail sn uid).collect{|key| "(#{key.to_s}=#{query}*)" }.join + ")"
    User.find(:all, :filter => search_string)
  end

  def self.find_by_group(group_name)
    User.find(:all, :base=>Group.find(:first, :attribute=>'cn', :value=>params[:group]).dn)
  end

  def edit_by_params(params)
    User.save_fields.each do |key|
      if key == 'userPassword'
         params[key].to_s.strip.empty? ? (self.userPassword = self.userPassword) : self.send("#{key}=", User.get_password_hash(params[key].to_s.strip))
      elsif key == 'l'
        str = app_list_by_hash(params[:applications])
        self.send("#{key}=",str)
      elsif key == 'cn'
        self.send("#{key}=", self.uid)
      else
        self.send("#{key}=", params[key].to_s.strip)
      end
    end
  end


  def self.create_by_params(params)
    user = User.new(params[:uid])

    User.save_fields.each do |key|
      if key == 'userPassword'
        user.send("#{key}=", User.get_password_hash(params[key].to_s.strip))
      elsif key == 'l'
        str = params[:applications].to_a.flatten.uniq.map{|el| el if User.application_list.include?(el)}.compact.join(', ') # получаем список приложений
        user.send("#{key}=",str)
      elsif key == 'cn'
        user.send("#{key}=",params[:uid])
      else
        user.send("#{key}=",params[key].to_s.strip)
      end
    end
    user
  end

  def get_field(field_name)
    self.attributes[field_name].is_a?(Array) ? self.attributes[field_name].flatten.join(', ') : self.attributes[field_name].to_s
  end

  private

  def app_list_by_hash(hash)
    hash.to_a.flatten.uniq.map{|el| el if User.application_list.include?(el)}.compact.join(', ') # получаем список приложений
  end

  def self.allow_to_all(app_id)
    if Application.find(app_id)
      app_name = Application.find(app_id).name
      User.all.each do |user|
        if user.l and user.l.include?(app_name)
          ar = user.l.split(',')
          ar.delete(app_name)
          user.l = ar.join(',')
          user.save
        end
      end
    end
  end

  #def self.deny_to_all(app_id)
  #  if Application.find(app_id)
  #    app_name = Application.find(app_id).name
  #    User.all.each do |user|
  #      if user.l.nil?
  #        user.l = app_name
  #        user.save
  #      elsif !user.l.include?(app_name)
  #        user.l = user.l.split(',').push(app_name).join(',')
  #        user.save
  #      end
  #    end
  #  end
  #end
  #
  #def self.edit_app_name(app_id, new_name)
  #  if Application.find(app_id)
  #    app_name = Application.find(app_id).name
  #    User.all.each do |user|
  #      if user.l and user.l.include?(app_name)
  #        user.l = user.l.gsub(app_name, new_name)
  #        #ar = user.l.split(',')
  #        #ar.delete(app_name)
  #        #user.l = ar.join(',')
  #        user.save
  #      end
  #    end
  #  end
  #end
end