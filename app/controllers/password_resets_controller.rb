class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]

  def new
  end

  def edit
    if current_user.is_admin && (current_user.group == get_user.group)
    elsif current_user.id == get_user.id
    else
      redirect_to user_path(current_user)
    end
  end

  def update
    if both_passwords_blank?
      flash.now[:notice] = "密码不能为空！"
      render 'edit'
    elsif @user.update_attributes(user_params)
      flash[:notice] = "密码重置成功！"
      if current_user.is_admin
        redirect_to users_path
      else
        redirect_to user_path(get_user)
      end
    else
      render 'password_reset'
    end
  end

  def primt_user
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def both_passwords_blank?
    params[:user][:password].blank? && params[:user][:password_confirmation].blank?
  end

  def get_user
    @user = User.find(params[:id])
  end

  # 确认用户有效
end
