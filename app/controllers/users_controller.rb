class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :password_reset]
  before_action :isspy, only: [:new, :create, :update, :destroy, :edit]
  before_action :is_login, only: [:index, :show, :edit, :update]

  def is_login
    redirect_to root_path unless current_user
  end

  def index
    @users = User.where(group: current_user.group).all
  end

  def new
    @user = User.new()
    if current_user
      @user.group = current_user.group
    end
  end

  def create
    @user = User.new(user_params)

    if current_user
      @user.branch = Branch.where(group: current_user.group).first.root.id
    end

    if verify_rucaptcha?(@user) && @user.save
      if current_user
        @user.update(:group => current_user.group)
        redirect_to edit_user_path(@user)
      else
        @user.update(:grade => 9)
        @user.update(:group => @user.id)
        @user.init_branches
        @user.init_categories
        flash[:success] = "您已经成为顶级管理员，热烈欢迎~"
        redirect_to login_path
      end
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def edit_avatar
    @user = User.find(params[:id])
  end

  def update_avatar
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to user_path(@user)
    else
      render 'edit_avatar', error: "更改头像失败~"
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to users_path, notice: '用户信息更新成功~'
    else
      render 'edit', :error => "更新信息失败！"
    end
  end
  def destroy
    if set_user.is_creator
      redirect_to users_path, notice: '不能删除系统初始用户！'
    else
      set_user.destroy
      redirect_to users_path
    end
  end

  def isspy
    if current_user && current_user.is_spy
      redirect_to users_path, :notice => "您的权限仅此而已~"
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :branch, :grade, :password, :password_confirmation, :group, :avatar)
  end

  def both_passwords_blank?
    params[:user][:password].blank? && params[:user][:password_confirmation].blank?
  end
end
