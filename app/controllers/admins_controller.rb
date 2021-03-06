class AdminsController < ApplicationController

  before_filter :check_super_admin
  respond_to :html, :js

  def manage_admin_and_users_list
    @admins = User.where(admin: true)
    @admins = @admins.paginate(:page => params[:admin_pagination])

    @users = User.where(admin: false)
    @users = @users.paginate(:page => params[:user_pagination])

    #RESETTING ALL THE SESSION VALUES STORED FOR PAGINATION TO DEFAULT WHEN NAVIGATING HERE
    reset_session_values

  end

  def make_user_admin
    @user = User.find(params[:id])
    authorize! :update, @user
    @user.admin = true
    @user.save
    @admins = User.where(admin: true)
    @admins = @admins.paginate(:page => params[:admin_pagination])

    respond_to do |format|
      format.js {}
    end

  end

  def remove_user_from_admin
    @user = User.find(params[:id])
    authorize! :create, @user
    @user.admin = false
    @user.save
    @users = User.where(admin: false)
    @users = @users.paginate(:page => params[:user_pagination])
  end

  def add_admin_form
    @admin = User.new(admin: true)
    authorize! :create, @admin
  end

  def add_admin
    @admin = User.new(user_params)
    @admin.password = Devise.friendly_token[0,20]
    authorize! :create, @admin


    if @admin.save
      flash[:success] = 'Admin successfully added'
      redirect_to manage_admin_and_users_list_admins_path
    else
        render 'add_admin_form'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :admin)
  end
 end
