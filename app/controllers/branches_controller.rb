class BranchesController < ApplicationController
  before_action :set_branch, only: [:show, :edit, :update, :destroy]
  before_action :isspy, only: [:new, :edit, :create, :update, :destroy]
  before_action :is_login

  def is_login
    redirect_to root_path unless current_user
  end

  # GET /branches
  # GET /branches.json
  def index
    if current_user.is_admin || current_user.is_spy
      if params[:branch]
        @branches = Branch.find(params[:branch]).children.order("branch_id")
      else
        @branches = Branch.where(group: current_user.group, ancestry: nil).first.children.order("branch_id")
      end
    else
      if params[:branch]
        @branches = Branch.find(params[:branch]).children.order("branch_id")
      else
        @branches = current_user.branches
      end
    end
  end

  # GET /branches/1
  # GET /branches/1.json
  def show
  end

  # GET /branches/new
  def new
    @branch = Branch.new
    @branch.group = current_user.group
  end

  # GET /branches/1/edit
  def edit
  end

  # POST /branches
  # POST /branches.json
  def create
    @branch = Branch.find(branch_params[:master_id])

    respond_to do |format|
      if @branch.children.create(branch_params)
        format.html { redirect_to branches_path, notice: '部门创建成功，可喜可赫.' }
        format.json { render :show, status: :created, location: @branch }
      else
        format.html { render :new }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /branches/1
  # PATCH/PUT /branches/1.json
  def update
    respond_to do |format|
      if @branch.id == branch_params[:master_id]
        format.html { render :edit, notice: '哪有自己隶属于自己的呢？' }
      elsif @branch.master_id == 1 && branch_params[:master_id] != 1
        format.html { render :edit, notice: '这是个顶级网点，暂不支持给它降级~' }
      else
        if @branch.update(branch_params)
          format.html { redirect_to branches_path, notice: '部门信息更新成功，可喜可赫.' }
          format.json { render :show, status: :ok, location: @branch }
        else
          format.html { render :edit }
          format.json { render json: @branch.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /branches/1
  # DELETE /branches/1.json
  def destroy
    if @branch.destroy
      respond_to do |format|
        format.html { redirect_to branches_url, notice: '这个部门删除成功，我早就看着不顺眼了~.' }
        format.json { head :no_content }
      end
    else
      redirect_to :back, alert: '不能删除存有设备或有下级的部门~！！'
    end
  end

  def isspy
    if current_user.is_spy
      flash[:error] = "您的权限仅此而已~"
      redirect_to branches_path
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_branch
    @branch = Branch.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def branch_params
    params.require(:branch).permit(:branch_id, :branch, :master_id, :description, :manager_id, :group )
  end
end
