class MerchandisesController < ApplicationController
  before_action :set_merchandise, only: [:show, :edit, :update, :destroy]
  layout :resolve_layout

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
        if @merchandise.youtube.match(/youtube.com/) || @merchandise.youtube.match(/youtu.be/)
          youtubeparsed = parse_youtube @merchandise.youtube
          @merchandise.update_attribute(:youtube, youtubeparsed)
        end
        redirect_to user_profile_path(current_user.permalink), notice: 'Patron Perk was successfully created.'
      else
        if @merchandise.youtube.match(/youtube.com/) || @merchandise.youtube.match(/youtu.be/)
          youtubeparsed = parse_youtube @merchandise.youtube
          @merchandise.update_attribute(:youtube, youtubeparsed)
        end
        project = Project.find_by_id(merchandise_params[:project_id])
        redirect_to project_standardperks_path(project.permalink), notice: 'Patron Perk was successfully created.'
      end  
    else
      render action: 'new', :notice => "Your merchandise was not saved. Check the required info (*), filetypes, or character counts."
    end
  end

  # PATCH/PUT /merchandises/1
  def update
    @merchandise = Merchandise.find(params[:id])
    if merchandise_params[:project_id].present? && @merchandise.update(merchandise_params)
      @project = Project.find(@merchandise.project_id)
      if @merchandise.youtube.match(/youtube.com/) || @merchandise.youtube.match(/youtu.be/)
        youtubeparsed = parse_youtube @merchandise.youtube
        @merchandise.update_attribute(:youtube, youtubeparsed)
      end
      redirect_to edit_project_path(@project.permalink), notice: 'Patron Perk was successfully added to project.'
    elsif @merchandise.update(merchandise_params)
      if @merchandise.youtube.match(/youtube.com/) || @merchandise.youtube.match(/youtu.be/)
        youtubeparsed = parse_youtube @merchandise.youtube
        @merchandise.update_attribute(:youtube, youtubeparsed)
      end
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
      @user = User.find(@merchandise.user_id)
    end

    def parse_youtube url
      regex = /(?:youtu.be\/|youtube.com\/watch\?v=|youtube.com\/embed\/|\/(?=p\/))([\w\/\-]+)/
      if url.match(regex)
        url.match(regex)[1]
      end
    end

    def merchandise_params
      params.require(:merchandise).permit(:name, :user_id, :price, :desc, :itempic,
       :project_id, :goal, :deadline, :youtube)
    end

    def resolve_layout
      case action_name
      when "show", "edit"
        'userpgtemplate'
      else
        'application'
      end
    end
end
