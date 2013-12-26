class ProjectsController < ApplicationController

  before_action :set_project, only: [:show, :edit, :update, :destroy]

  before_action :set_nav_item_name

  before_action do |controller|
    actions = ['edit', 'updtae', 'destroy']
    return unless actions.include? action_name
    role = current_user.role
    project = Project.find params[:id]
    unless role == 'admin' or project.managers.all.include? current_user
      redirect_to projects_path, :alert => '访问被拒绝，您可能没有权限或未登录。'
    end
  end

  # GET /projects
  # GET /projects.json
  def index

    search_condition = case params[:search_key]
                         when 'name'
                           Project.where('name like ?', "%#{params[:search_value]}%")
                         when 'id'
                           Project.where(:id => params[:search_value].to_i)
                         when 'manager'
                           Project.joins(:managers).where('users.name like ?', "%#{params[:search_value]}%").uniq
                       end

    if current_user.role == 'admin'
      @projects = Project.page.merge(search_condition).page(params[:page])
    else
      @projects = current_user.managed_projects.merge(search_condition).page(params[:page])
    end

    @search_form = {
      :path => projects_path,
      :search_value => params[:search_value] || '',
      :search_key => (params[:search_key]  || :name).to_sym,
      :key_options => {
        :name => '名称',
        :id => 'ID',
        :manager => '管理员'
      }
    }.with_indifferent_access
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
    @project.managers << current_user
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    def set_nav_item_name
      @nav_item_name = 'management'
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :description, :public, :manager_ids => [], :member_ids => [])
    end
end
