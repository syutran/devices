class ManageController < ApplicationController
  before_action :is_login

  def is_login
    redirect_to root_path unless current_user
  end

  def index
    @turnup_devices = Device.where(:group => current_user.group,:status => 3).count
    @stock_devices  = Device.where("devices.group = ? and devices.branch_id = ? and devices.status < 7", current_user.group, current_user.root_branch.id ).count
    @turnoff_devices = Device.where("devices.group = ? and devices.status >= 7", current_user.group).count
  end

  def turnup_list
    @turnup_devices = Device.where(:group => current_user.group, :status => 3).page params[:page]
  end
  def turnoff_list
    @turnoff_devices = Device.where("devices.group = ? and devices.status >= 7", current_user.group).page params[:page]
  end
  def agree_turnup
    @device = Device.find(params[:id])
    @device.update(:status=> 5, :branch_id => current_user.root_branch.id, :description => "#{@device.description}\n#{@device.branch.branch}交回")
    redirect_to manage_turnup_list_path 
  end

  def stock_list
    @stock_devices = Device.where("devices.group = ? and devices.branch_id = ? and devices.status < 7", current_user.group, current_user.root_branch.id ).page params[:page]
  end
  def turnoff
    @device = Device.find(params[:id])
    @device.update(:status => 7, :description => "#{@device.description}\n#{current_user.name}执行报废！")
    redirect_to manage_stock_list_path
  end

  def show_device
    @device = Device.find(params[:id])
  end
  def allot
    @device = Device.find(params[:id])
  end
  def put_allot
    @device = Device.find(params[:id])
    if @device.update(device_params)
      @device.update(:status => 0)
      redirect_to manage_device_path(@device)
    else
      render :allot
    end
  end

  def change_status
    @device = Device.find(params[:id])
    @device.update(:status => params[:status])
    redirect_to manage_device_path(@device)
  end

  private
    def device_params
      params.require(:device).permit(:title, :manufacturer, :seller, :dev_class, :dev_model, :serial_number, :parameter, :purchased, :used, :invalided, :branch_id, :custodian, :user, :status, :changed_date, :contacts, :description)
    end
end
