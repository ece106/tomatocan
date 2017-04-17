class MerchandisesController < ApplicationController
  before_action :set_merchandise, only: [:show, :edit, :update, :destroy]

  # GET /merchandises
  def index
    @merchandises = Merchandise.all
  end

  # GET /merchandises/1
  def show
    @author = User.find(@merchandise.user_id)
  end

  # GET /merchandises/new
  def new
    @merchandise = Merchandise.new
  end

  # GET /merchandises/1/edit
  def edit
  end

  # POST /merchandises
  def create
    @merchandise = current_user.merchandises.build(merchandise_params)
    if @merchandise.save 
      if merchandise_params[:project_id] == nil
        redirect_to user_profile_path(current_user.permalink), notice: 'Patron Perk was successfully created.'
      else
        project = Project.find_by_id(merchandise_params[:project_id])
        redirect_to project_standardperks_path(project.permalink), notice: 'Patron Perk was successfully created.'
      end  
    else
      render action: 'new', :notice => "Your merchandise was not saved. Check the required info (*), filetypes, or character counts."
    end
  end

  # PATCH/PUT /merchandises/1
  def update
    if merchandise_params[:project_id].present? && @merchandise.update(merchandise_params)
      @project = Project.find(@merchandise.project_id)
      redirect_to edit_project_path(@project.id), notice: 'Patron Perk was successfully added to project.'
    elsif @merchandise.update(merchandise_params)
      redirect_to @merchandise, notice: 'Patron Perk was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /merchandises/1
  def destroy
    @merchandise.destroy
    redirect_to merchandises_url, notice: 'Merchandise was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_merchandise
      @merchandise = Merchandise.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def merchandise_params
      params.require(:merchandise).permit(:name, :user_id, :price, :desc, :itempic, :project_id, :goal, :deadline)
    end
end
