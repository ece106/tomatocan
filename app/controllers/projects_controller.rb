class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  def index
    @projects = Project.all
    @support = []
    active = Project.where("deadline > ?", Time.now) 
    active.find_each do |proj|
      author = User.find(proj.user_id).name
      @support <<  {name: proj.name, creator: author, mission: proj.mission, id: proj.id} 
    end 
    @currusergroup = Group.where("user_id > ?", current_user.id) 
  end

  def addprojecttogroup
    puts "HHHHHHHHHHHHHHOOOOOOOOOOOOO"
    #Agreements.group_id = @currusergroup.id 
    #@project_id = project.id
  end

  # GET /projects/1
  def show
    @merchandise = @project.merchandises
    @author = User.find(@project.user_id)
    @merchandises = @author.merchandises
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  def newloot  
    @project = Project.find_by_permalink(params[:permalink])
    @merchandises = @project.merchandises
    @merchandise = @project.merchandises.build 
    @lootlist = Merchandise.where(:project_id => @project.id)
    dropdown1 = Merchandise.where( "user_id = ?", current_user.id).where('project_id IS NULL')
    dropdown2 = Merchandise.where( "user_id = ?", current_user.id).where("project_id != ?", @project.id)
    @dropdown = dropdown1 + dropdown2
  end

  # GET /projects/1/edit
  def edit
    @lootlist = Merchandise.where( "user_id = ?", current_user.id)
    dropdown1 = Merchandise.where( "user_id = ?", current_user.id).where('project_id IS NULL')
    dropdown2 = Merchandise.where( "user_id = ?", current_user.id).where("project_id != ?", @project.id)
    @dropdown = dropdown1 + dropdown2
    @merchandise = @project.merchandises.build 
  end

  # POST /projects
  def create
    @project = current_user.projects.build(project_params)
    if @project.save
      redirect_to project_newloot_path(@project.permalink), notice: 'Project was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.friendly.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:name, :user_id, :mission, :projectpic, :permalink, :deadline)
    end
end
