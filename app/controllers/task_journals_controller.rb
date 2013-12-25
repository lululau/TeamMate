class TaskJournalsController < ApplicationController
  before_action :set_task_journal, only: [:show, :edit, :update, :destroy]

  # GET /task_journals
  # GET /task_journals.json
  def index
    @task_journals = TaskJournal.all
  end

  # GET /task_journals/1
  # GET /task_journals/1.json
  def show
  end

  # GET /task_journals/new
  def new
    @task_journal = TaskJournal.new
  end

  # GET /task_journals/1/edit
  def edit
  end

  # POST /task_journals
  # POST /task_journals.json
  def create
    @project = Project.find params[:project_id]
    @task = Task.find params[:task_id]
    @task_journal = @task.task_journals.build(task_journal_params)
    @task_journal.operator_id = current_user.id
    @task_journal.old_done_ratio = @task.ratio

    respond_to do |format|
      if @task_journal.save
        @task.update :ratio => @task_journal.new_done_ratio,
                     :time_entry_hours => @task.time_entry_hours + task_journal_params[:time_entry_hours].to_i
        UserMailer.task_changed(@task_journal).deliver
        format.html { redirect_to [@project, @task], notice: 'Task journal was successfully created.' }
        format.json { render action: 'show', status: :created, location: [@project, @task] }
      else
        format.html { render action: 'new' }
        format.json { render json: @task_journal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_journals/1
  # PATCH/PUT /task_journals/1.json
  def update
    respond_to do |format|
      if @task_journal.update(task_journal_params)
        format.html { redirect_to @task_journal, notice: 'Task journal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @task_journal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_journals/1
  # DELETE /task_journals/1.json
  def destroy
    @task_journal.destroy
    respond_to do |format|
      format.html { redirect_to task_journals_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_journal
      @task_journal = TaskJournal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_journal_params
      params.require(:task_journal).permit(:time_entry_hours, :old_done_ratio, :new_done_ratio, :task_id, :operator_id)
    end
end
