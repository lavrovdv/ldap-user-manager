# encoding: UTF-8
class ApplicationsController < ApplicationController
  # GET /applications
  # GET /applications.json
  def index
    @applications = Application.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @applications }
    end
  end

  # GET /applications/1
  # GET /applications/1.json
  def show
    @application = Application.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @application }
    end
  end

  # GET /applications/new
  # GET /applications/new.json
  def new
    @application = Application.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @application }
    end
  end

  # GET /applications/1/edit
  def edit
    @application = Application.find(params[:id])
  end

  # POST /applications
  # POST /applications.json
  def create
    @application = Application.new()
    @application.name = params[:application][:name].to_s.downcase
    # true - доступ запрещен, false - разрешен
    @application.default = true
    respond_to do |format|
      if @application.save
        format.html { redirect_to applications_path, notice: 'Приложение создано.' }
        format.json { render json: @application, status: :created, location: @application }
      else
        format.html { render action: "new" }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /applications/1
  # PUT /applications/1.json
  def update
    @application = Application.find(params[:id])
    new_name = params[:application][:name].to_s.downcase
    @application.name = params[:application][:name]
    User.edit_app_name(@application.id, new_name) if @application.valid?

    respond_to do |format|
      if @application.update_attributes(params[:application])
        format.html { redirect_to applications_path, notice: 'Приложение обновлено.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /applications/1
  # DELETE /applications/1.json
  def destroy
    @application = Application.find(params[:id])
    User.allow_to_all(@application.id) # перед удалением снимаем все запреты для данного приложения.
    @application.destroy
    respond_to do |format|
      format.html { redirect_to applications_url, notice: 'Приложение удалено.' }
      format.json { head :ok }
    end
  end

  def allow
    #User.allow_to_all(params[:id])
    app = Application.find(params[:id])
    if app
      app.default = false
      app.save
      flash[:allow] = "Доступ по умолчаню разрешен, для приложения - #{app.name}"
    else
      flash[:deny] = "Приложение не найдено"
    end
    redirect_to applications_url
  end

  def deny
    #User.deny_to_all(params[:id])
    app = Application.find(params[:id])
    if app
      app.default = true
      app.save
      flash[:deny] = "Доступ по умолчаню запрещен, для приложения - #{app.name}"
    else
      flash[:deny] = "Приложение не найдено"
    end
    redirect_to applications_url
  end
end
