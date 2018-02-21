class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy, :turn_normal, :change_status, :edit_avatar, :update_avatar]
  before_action :is_login
  before_action :isspy, only: [:new, :edit, :udpate, :destroy, :trun_normal, :change_status, :edit_avatar, :update_avatar, :branch_devices_to_xlsx, :drop_versions]
  # GET /devices
  # GET /devices.json
  def is_login
    unless current_user
      redirect_to root_path
    end
  end

  def index
    # 如果是系统管理员或窃密者
    if current_user.is_admin || current_user.is_spy
      case
      when params[:branch] && params[:dev_class]
        @devices = Device.where(:group => current_user.group, :branch_id => params[:branch], :dev_class => params[:dev_class]).page params[:page]
        @dev_classes = Device.where(branch_id: params[:branch]).where.not(dev_class: nil).group("dev_class").count
      when params[:user] && params[:branch]
        @devices = Device.where(:group => current_user.group, :user => params[:user], branch_id: params[:branch]).page params[:page]
        @users_devices = Device.where(group: current_user.group, branch_id: params[:branch]).group(:user).count
      when params[:branch]
        @devices = Device.where(:group => current_user.group, :branch_id => params[:branch]).page params[:page]
        @dev_classes = Device.where(branch_id: params[:branch]).where.not(dev_class: nil).group("dev_class").count
      when params[:dev_model]
        @devices = Device.where(:group => current_user.group, :dev_model => params[:dev_model]).order("branch_id").page params[:page]
      when params[:dev_class]
        @devices = Device.where(:group => current_user.group, :dev_class => params[:dev_class]).order("branch_id").page params[:page]
        @dev_class_branches = Device.where(group: current_user.group, dev_class: params[:dev_class]).group(:branch_id).count
      else
        redirect_to branches_path
      end
    # 普通管理员
    elsif current_user.branches.any?
      case
      when params[:user] && params[:branch]
        @devices = Device.where(group: current_user.group, branch_id: params[:branch], user: params[:user]).page params[:page]
        @users_devices = Device.where(group: current_user.group, branch_id: params[:branch]).group(:user).count
      when params[:branch] && params[:dev_class]
        @devices = Device.where(group: current_user.group, branch_id: params[:branch], dev_class: params[:dev_class]).where.not(dev_class: nil).page params[:page]
        @dev_classes = Device.where(group: current_user.group, branch_id: params[:branch]).where.not(dev_class: nil).group(:dev_class).count
      when params[:branch]
        @devices = Device.where(group: current_user.group, branch_id: params[:branch]).page params[:page]
        @dev_classes = Device.where(group: current_user.group, branch_id: params[:branch]).where.not(dev_class: nil).group(:dev_class).count
      else
        if current_user.branches.many?
          redirect_to branches_path
        else
          redirect_to devices_path(branch: current_user.branches.first)
        end
      end
    else
      redirect_to user_path(current_user), notice: "您没有可查看的部门设备"
    end
  end
  # GET /devices/1
  # GET /devices/1.json
  def show
  end

  # GET /devices/new
  def new
    @device = Device.new
    if current_user.is_admin
      @device.branch_id = current_user.root_branch.id
    else
      @device.branch_id = current_user.branches.first.id if current_user.branches.any?
    end
  end

  # GET /devices/1/edit
  def edit
    if current_user.is_admin && (current_user.group == @device.group)
    elsif current_user.branches.ids.include? @device.branch_id
    else
      redirect_to devices_path 
    end
  end

  def branch_devices_to_xlsx
    branch = Branch.find(params[:id])
    @devices = branch.devices
    respond_to do |format|
      format.xlsx {
        response.headers['Content-Disposition'] = "attachment; filename=eqtools.#{branch.branch}.#{Time.now.year}#{Time.now.month}#{Time.now.day}.#{Time.now.hour}#{Time.now.min}.xlsx"
      }
    end
  end

  def history
    @versions = PaperTrail::Version.order('created_at DESC')
  end

  def drop_versions
    @device = Device.find(params[:id])
    PaperTrail::Version.delete_all(item_id: @device.id)
    redirect_to device_path(@device)
  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(device_params)

    respond_to do |format|
      if @device.save
        @device.update_column(:group, current_user.group)
        if @device.branch.is_root?
          @device.update(:status => 4)
        end
        format.html { redirect_to device_path(@device), notice: '成功添加新设备~' }
        format.json { render :show, status: :created, location: @device }
      else
        format.html { render :new }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    respond_to do |format|
      if @device.update(device_params)
        format.html { redirect_to device_path(@device), notice: '设备信息更新成功~' }
        format.json { render :show, status: :ok, location: @device }
      else
        format.html { render :edit }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
  end
  def change_status
    @device.update(:status => params[:status])
    redirect_to devices_path
  end

  def edit_avatar

  end

  def update_avatar
    respond_to do |format|
      if @device.update(device_params)
        format.html { redirect_to device_path(@device), notice: '设备信息更新成功~' }
        format.json { render :show, status: :ok, location: @device }
      else
        format.html { render :edit }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  def isspy
    if current_user.is_spy
      flash[:error] = "您的权限仅此而已~"
      redirect_to devices_path
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_device
    @device = Device.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def device_params
    params.require(:device).permit(:title, :manufacturer, :seller, :dev_class, :dev_model, :serial_number, :parameter, :purchased, :used, :invalided, :branch_id, :custodian, :user, :status, :changed_date, :contacts, :description, :avatar, :tagboard, :custom)
  end
end
