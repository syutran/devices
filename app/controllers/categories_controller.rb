class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :isspy, only: [:new, :edit, :create, :udpate, :destroy]
  before_action :is_login

  def is_login
    redirect_to root_path unless current_user
  end

  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.where(group: current_user.group).all.order("master_id")
  end

  def to_xlsx
    respond_to do |format|
    @categories = Category.where(group: current_user.group).all.order("master_id")
      format.xlsx {
        response.headers['Content-Disposition'] = "attachment; filename=eqtools.#{current_user.root_branch}.#{Time.now.year}#{Time.now.month}#{Time.now.day}.#{Time.now.hour}#{Time.now.min}.xlsx"
      }
    end
  end
  def all_to_xlsx
    respond_to do |format|
    @all_devices = Devices.where(group: current_user.group).all.order("master_id")
      format.xlsx {
        response.headers['Content-Disposition'] = "attachment; filename=eqtools.#{current_user.root_branch}.#{Time.now.year}#{Time.now.month}#{Time.now.day}.#{Time.now.hour}#{Time.now.min}.xlsx"
      }
    end
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        @category.update_column(:group,current_user.group)
        format.html { redirect_to categories_path, notice: '创建分类成功，可喜可（he字不会打）.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.master_id == 1 && category_params[:master_id].to_i != 1
        format.html { render :edit, notice: '不能相互隶属，也不能把顶级分类降级~'}
      else
        if @category.update(category_params)
          format.html { redirect_to categories_path, notice: '分类修改成功，没事你就改着玩吧，哈~' }
          format.json { render :show, status: :ok, location: @category }
        else
          format.html { render :edit }
          format.json { render json: @category.errors, status: :unprocessable_entity }
        end
      end
    end
  end

    # DELETE /categories/1
    # DELETE /categories/1.json
    def destroy
      @category.destroy
      respond_to do |format|
        format.html { redirect_to categories_url, notice: '分类删除成功~' }
        format.json { head :no_content }
      end
    end

    def isspy
      if current_user.is_spy
        flash[:error] = "您的权限仅此而已~"
        redirect_to categories_path
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:title, :master_id, :description, :avatar)
    end
  end
