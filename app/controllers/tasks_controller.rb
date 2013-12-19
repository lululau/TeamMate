class TasksController < ApplicationController
  before_action :set_project
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_selected_project_cookie
  before_action :set_nav_item_name

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = @project.tasks.all
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = @project.tasks.build
    @task.assigned_to_user = current_user
    @task.priority = 3
    @task_options = Task.all
  end

  # GET /tasks/1/edit
  def edit
    @task_options = Task.where.not(:id => params[:id]).all
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = @project.tasks.build(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to [@project, @task], notice: 'Task was successfully created.' }
        format.json { render action: 'show', status: :created, location: [@project, @task] }
      else
        @task_options = Task
        @task_options = Task.all
        format.html { render action: 'new' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
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
