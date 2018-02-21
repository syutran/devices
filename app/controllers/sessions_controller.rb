class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      if user.is_admin
      redirect_to branches_path
      elsif user.branch
        redirect_to devices_path
      else
        redirect_to user
      end
      flash[:notice] = "welcome~ haha~"
    else
      # 创建一个错误消息
      flash[:error] = "好像哪儿不对劲哦~"
      render 'new'
    end
  end 

  def destroy
    log_out
    redirect_to sessions_new_path
  end
end
