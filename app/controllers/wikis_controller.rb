class WikisController < ApplicationController
  before_action :set_wiki, only: [:show, :edit, :update, :destroy]
  before_action :set_project
  before_action :set_selected_project_cookie
  before_action :set_nav_item_name

  before_action do |controller|
    if ['edit', 'update', 'create', 'destroy'].include? action_name
      role = current_user.role
      unless role == 'admin' or (@project.managers + @project.members).include? current_user
        redirect_to root_path, :alert => '访问被拒绝，您可能没有权限或未登录。'
        return
      end
    end
  end

  def root
    role = current_user.role
    unless role == 'admin' or @project.public or (@project.managers + @project.members).include? current_user
      redirect_to root_path, :alert => '访问被拒绝，您可能没有权限或未登录。'
      return
    end
    if @project.root_wiki_id
      root_wiki = Wiki.find @project.root_wiki_id
      if root_wiki.present?
        @wiki = root_wiki
        render :show
      else
        @wiki = Wiki.new :content => "# Root Wiki\r\n\r\n", :author => current_user
        render :new
      end
    else
      @wiki = Wiki.new :content => "# Root Wiki\r\n\r\n", :author => current_user
      render :new
    end
  end

  def show_or_new
    subject = params[:subject]
    @wiki = @project.wikis.find_by :subject => subject
    role = current_user.role
    if @wiki
      unless role == 'admin' or @project.public or (@project.managers + @project.members).include? current_user
        redirect_to root_path, :alert => '访问被拒绝，您可能没有权限或未登录。'
        return
      end
      render :show
    else
      unless role == 'admin' or (@project.managers + @project.members).include? current_user
        if @project.public
          redirect_to root_path, :alert => '访问的 Wiki 不存在。'
        else
          redirect_to root_path, :alert => '访问被拒绝，您可能没有权限或未登录。'
        end
        return
      end
      @parent = Wiki.find params[:parent_id]
      @wiki = @project.wikis.build :content => "# #{subject}", :author => current_user, :parent => @parent
      render :new
    end
  end



  # GET /wikis
  # GET /wikis.json
  def index
    @wikis = Wiki.all
  end

  # GET /wikis/1
  # GET /wikis/1.json
  def show
  end

  # GET /wikis/new
  def new
    @wiki = Wiki.new
  end

  # GET /wikis/1/edit
  def edit
  end

  # POST /wikis
  # POST /wikis.json
  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.project_id = params[:project_id]
    @wiki.author = current_user
    @wiki.subject = wiki_params[:content].gsub(/\r\n.*|^#\s*/m, '')

    respond_to do |format|
      if @wiki.save
        if @wiki.parent_id
          if @wiki.parent.project_id != @project.id
            if @project.root_wiki_id
              @wiki.update :parent_id => @project.root_wiki_id
              format.html { redirect_to project_show_or_new_wiki_path(@project, @wiki.parent_id, @wiki.subject), notice: 'Wiki was successfully created.' }
            else
              @wiki.update :parent_id => nil
              @project.update :root_wiki_id => @wiki.id
              format.html { redirect_to project_root_wiki_path(@project), notice: 'Wiki was successfully created.' }
            end
          else
            format.html { redirect_to project_show_or_new_wiki_path(@project, @wiki.parent_id, @wiki.subject), notice: 'Wiki was successfully created.' }
          end
        else
          @project.root_wiki_id = @wiki.id
          @project.save
          format.html { redirect_to project_root_wiki_path(@project), notice: 'Wiki was successfully created.' }
          format.json { render action: 'show', status: :created, location: @wiki }
        end
      else
        format.html { render action: 'new' }
        format.json { render json: @wiki.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wikis/1
  # PATCH/PUT /wikis/1.json
  def update
    respond_to do |format|
      if @wiki.update(wiki_params.merge(:subject => wiki_params[:content].gsub(/\r\n.*|^#\s*/m, ''), :project_id => params[:project_id]))
        if wiki_params[:parent_id].present?
          format.html { redirect_to project_show_or_new_wiki_path(@project, wiki_params[:parent_id], @wiki.subject), notice: 'Wiki was successfully updated.' }
        else
          format.html { redirect_to project_root_wiki_path(@project), notice: 'Wiki was successfully updated.' }
        end
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @wiki.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wikis/1
  # DELETE /wikis/1.json
  def destroy
    if @project.root_wiki_id == @wiki.id
      @project.update :root_wiki_id => nil
    end
    @wiki.destroy
    respond_to do |format|
      format.html { redirect_to project_root_wiki_path @project }
      format.json { head :no_content }
    end
  end

  private

    def set_project
      @project = Project.find params[:project_id]
    end

    def set_selected_project_cookie
      cookies[:selected_project] = params[:project_id]
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_wiki
      @wiki = Wiki.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wiki_params
      params.require(:wiki).permit(:subject, :content, :parent_id, :project_id, :author_id, :contributor_ids => [])
    end

    def set_nav_item_name
      @nav_item_name = 'selected-project'
    end
end
