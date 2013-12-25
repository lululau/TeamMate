class TasksController < ApplicationController
  before_action :set_project
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_selected_project_cookie
  before_action :set_nav_item_name

  before_action do |controller|
    actions = ['new', 'create', 'edit', 'update', 'destroy']
    role = current_user.role
    if actions.include? action_name
      unless role == 'admin' or (@project.managers + @project.members).include? current_user
        redirect_to root_path, :alert => '访问被拒绝，您可能没有权限或未登录。'
      end
    end
  end


  # GET /tasks
  # GET /tasks.json
  def index
    role = current_user.role
    unless role == 'admin' or @project.public or (@project.managers + @project.members).include? current_user
      redirect_to root_path, :alert => '访问被拒绝，您可能没有权限或未登录。'
      return
    end
    @tasks = @project.tasks.all
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    role = current_user.role
    unless role == 'admin' or @project.public or (@project.managers + @project.members).include? current_user
      redirect_to root_path, :alert => '访问被拒绝，您可能没有权限或未登录。'
      return
    end
  end

  # GET /tasks/new
  def new
    @task = @project.tasks.build
    @task.assigned_to_user = current_user
    @task.priority = 3
    @task_options = @project.tasks
  end

  # GET /tasks/1/edit
  def edit
    @task_options = @project.tasks.where.not(:id => params[:id]).all
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = @project.tasks.build(task_params)
    allowed_user_ids = @project.manager_ids + @project.member_ids + User.where(:role => 'admin').ids
    unless allowed_user_ids.include? @task.assigned_to_user_id
      @task.errors.add(:assigned_to_user, "不能选择这个用户: #{@task.assigned_to_user.name}")
    end

    disallowed_user_names = []
    @task.watchers.each do |w|
      unless allowed_user_ids.include? w.id
        disallowed_user_names << w.name
      end
    end

    if disallowed_user_names.any?
      @task.errors.add(:watchers, "不能选择这些用户: #{disallowed_user_names.join ", "}")
    end

    if @task.errors.any?
      respond_to do |format|
        @task_options = Task.all
        format.html { render action: 'new' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
      return
    end

    respond_to do |format|
      if @task.save
        UserMailer.task_assigned(@task).deliver
        format.html { redirect_to [@project, @task], notice: 'Task was successfully created.' }
        format.json { render action: 'show', status: :created, location: [@project, @task] }
      else
        @task_options = Task.all
        format.html { render action: 'new' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    allowed_user_ids = (@project.manager_ids + @project.member_ids + User.where(:role => 'admin').ids).map {|id| id.to_s}
    unless allowed_user_ids.include? task_params[:assigned_to_user_id]
      @task.errors.add(:assigned_to_user, "不能选择这个用户: #{User.find(task_params[:assigned_to_user_id]).name}")
    end

    disallowed_user_names = []
    task_params[:watcher_ids].delete_if{|x|x == ""}.each do |id|
      unless allowed_user_ids.include? id
        disallowed_user_names << User.find(id).name
      end
    end

    if disallowed_user_names.any?
      @task.errors.add(:watchers, "不能选择这些用户: #{disallowed_user_names.join ", "}")
    end

    original_assigned_to_user_id = @task.assigned_to_user_id.to_s
    if original_assigned_to_user_id != task_params[:assigned_to_user_id]
      if current_user.role != 'admin' and not @project.managers.include?(current_user) and @task.assigned_to_user != current_user
        redirect_to root_path, :alert => '访问被拒绝，您可能没有权限或未登录。'
        return
      end
    end

    if @task.errors.any?
      respond_to do |format|
        @task_options = Task.all
        format.html { render action: 'edit' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
      return
    end
    respond_to do |format|
      if @task.update(task_params)
        if original_assigned_to_user_id != task_params[:assigned_to_user_id]
          UserMailer.task_assigned(@task).deliver
        end
        format.html { redirect_to [@project, @task], notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        @task_options = Task.where.not(:id => params[:id]).all
        format.html { render action: 'edit' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to project_tasks_path(@project) }
      format.json { head :no_content }
    end
  end

  private

    def set_project
      @project = Project.find params[:project_id]
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:category, :subject, :description, :priority, :start_date, :due_date, :at_risk, :reason_of_risk, :assigned_to_user_id, :parent_id, :project_id, :watcher_ids => [])
    end

    def set_selected_project_cookie
      cookies[:selected_project] = params[:project_id]
    end

    def set_nav_item_name
      @nav_item_name = 'selected-project'
    end
end
