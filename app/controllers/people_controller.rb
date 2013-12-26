class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy]

  before_action :set_nav_item_name, :except => [:tasks, :activities]

  before_action do |controller|
    actions = ['edit', 'update', 'destroy']
    return unless actions.include? action_name
    role = current_user.role
    if role == 'admin'
      if @person.role == 'admin'
        redirect_to people_path, :alert => '访问被拒绝，您可能没有权限或未登录。'
        return
      end
    elsif role == 'manager'
      if ['admin', 'manager'].include? @person.role
        redirect_to people_path, :alert => '访问被拒绝，您可能没有权限或未登录。'
        return
      end
    end
  end


  def tasks
    search_condition = case params[:search_key]
                         when 'subject'
                           Task.where('subject like ?', "%#{params[:search_value]}%")
                         when 'id'
                           Task.where(:id => params[:search_value].to_i)
                         when 'parent_subject'
                           Task.joins(:parent).where('parents_tasks.subject like ?', "%#{params[:search_value]}%")
                         when 'parent_id'
                           Task.joins(:parent).where('parents_tasks.id = ?', params[:search_value].to_i)
                         when 'category'
                           categories = {
                             "Bug修复" => :bug_fixing,
                             "新增功能" => :new_feature,
                             "支持" => :support
                           }
                           category = params[:search_value]
                           matched_categories = []
                           categories.each_pair do |k, v|
                             if k.include? category
                               matched_categories << v
                             end
                           end
                           Task.where(:category => matched_categories)
                         when 'priority'
                           Task.where :priority => params[:search_value].to_i
                         when 'project'
                           Task.joins(:project).where('projects.name like ?', "%#{params[:search_value]}%")
                       end

    @type = params[:type]


    if @type and @type == 'watching'
      @tasks = current_user.watching_tasks.merge(search_condition).page params[:page]
    else
      @type = :assigned_to
      @tasks = current_user.tasks.merge(search_condition).page params[:page]
    end
    @nav_item_name = 'my-tasks'

    @search_form = {
      :path => my_tasks_path(@type),
      :search_value => params[:search_value] || '',
      :search_key => (params[:search_key]  || :subject).to_sym,
      :key_options => {
        :subject => '主题',
        :id => 'ID',
        :parent_subject => '父任务主题',
        :parent_id => '父任务ID',
        :category => '分类',
        :priority => '优先级',
        :project => '项目名称',
      }
    }.with_indifferent_access
  end

  def activities
    search_condition = case params[:search_key]
                         when 'subject'
                           TaskJournal.joins(:task).where('subject like ?', "%#{params[:search_value]}%")
                         when 'project'
                           TaskJournal.joins(:task => :project).where('projects.name like ?', "%#{params[:search_value]}%")
                       end
    @journals = current_user.task_activities.merge(search_condition).page params[:page]
    @type = :activities
    @nav_item_name = 'my-tasks'
    @search_form = {
      :path => my_activities_path,
      :search_value => params[:search_value] || '',
      :search_key => (params[:search_key]  || :subject).to_sym,
      :key_options => {
        :subject => '主题',
        :project => '项目名称',
      }
    }.with_indifferent_access
  end

  # GET /people
  # GET /people.json
  def index

    search_condition = case params[:search_key]
                         when 'name'
                           Person.where('name like ?', "%#{params[:search_value]}%")
                         when 'id'
                           Person.where(:id => params[:search_value].to_i)
                         when 'email'
                           Person.where('email like ?', "%#{params[:search_value]}%")
                         when 'role'
                           roles = {
                             '管理员' => :admin,
                             '部门经理' => :manager,
                             '普通用户' => :normal
                           }
                           role = params[:search_value]
                           matched_roles = []
                           roles.each_pair do |k, v|
                             if k.include? role
                               matched_roles << v
                             end
                           end
                           Person.where(:role => matched_roles)
                         else
                           Person.all
                       end
    @people = search_condition.page(params[:page])

    @search_form = {
      :path => people_path,
      :search_value => params[:search_value] || '',
      :search_key => (params[:search_key]  || :name).to_sym,
      :key_options => {
        :name => '用户名',
        :id => 'ID',
        :email => 'Email',
        :role => '角色'
      }
    }.with_indifferent_access
  end

  # GET /people/1
  # GET /people/1.json
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
    @person.role = Person::Role::NORMAL
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  # POST /people.json
  def create
    @person = Person.new(person_params)
    current_user_role = current_user.role
    person_role = person_params[:role]
    if current_user_role == 'admin'
      if person_role == 'admin'
        @person.errors.add :role, '您所创建的用户必须低于您的角色级别'
      end
    else
      if ['admin', 'manager'].include? person_role
        @person.errors.add :role, '您所创建的用户必须低于您的角色级别'
      end
    end

    if @person.errors.any?
      respond_to do |format|
        format.html { render action: 'new' }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
      return
    end

    respond_to do |format|
      if @person.save
        encrypted_password = Devise.bcrypt(Class.new do
          class << self
            Devise::Models.config self, :pepper, :stretches
          end
        end, person_params[:encrypted_password])
        @person.update :encrypted_password => encrypted_password, :encrypted_password_confirmation => encrypted_password
        unless @person.locked
          UserMailer.account_created(User.find(@person.id), person_params[:encrypted_password]).deliver
        end
        format.html { redirect_to @person, notice: 'Person was successfully created.' }
        format.json { render action: 'show', status: :created, location: @person }
      else
        format.html { render action: 'new' }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update

    current_user_role = current_user.role
    person_role = person_params[:role]
    if current_user_role == 'admin'
      if person_role == 'admin'
        @person.errors.add :role, '您所创建的用户必须低于您的角色级别'
      end
    else
      if ['admin', 'manager'].include? person_role
        @person.errors.add :role, '您所创建的用户必须低于您的角色级别'
      end
    end

    if @person.errors.any?
      respond_to do |format|
        format.html { render action: 'edit' }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
      return
    end

    original_locking_status = @person.locked
    params = person_params
    unless params[:encrypted_password].present?
      params.delete :encrypted_password
      params.delete :encrypted_password_confirmation
    end
    respond_to do |format|
      if @person.update(params)
        if params[:encrypted_password]
          encrypted_password = Devise.bcrypt(Class.new do
            class << self
              Devise::Models.config self, :pepper, :stretches
            end
          end, params[:encrypted_password])
          @person.update :encrypted_password => encrypted_password, :encrypted_password_confirmation => encrypted_password
          UserMailer.password_changed(User.find(@person.id), params[:encrypted_password]).deliver
        end
        if original_locking_status and ! @person.locked
          UserMailer.account_unlocked(User.find @person.id).deliver
        end
        format.html { redirect_to @person, notice: 'Person was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.html { redirect_to people_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    def set_nav_item_name
      @nav_item_name = 'management'
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:name, :email, :encrypted_password, :encrypted_password_confirmation, :role, :avatar, :locked)
    end
end
