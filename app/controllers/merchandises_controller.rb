class MerchandisesController < ApplicationController
  before_action :set_merchandise, only: [:show, :edit, :update, :destroy, :create, :new]
  layout :resolve_layout

  # GET /merchandises
  def index
    @merchandiselisa = Merchandise.joins(:user).where("user_id = 143 AND itempic IS NOT NULL")
    @merchandisepic = Merchandise.joins(:user).where("stripeid IS NOT NULL AND itempic IS NOT NULL")
    @merchandisenopic = Merchandise.joins(:user).where("stripeid IS NOT NULL AND itempic IS NULL")
  end

  # GET /merchandises/1
  def show
    @author = User.find(@merchandise.user_id)
  end

  # GET /merchandises/new
  def new
    if current_user.stripeid.present?
      @merchandise = Merchandise.new
      if params[:phase_id].present?
        @phase_id = params[:phase_id]
      end
    end
  end

  # GET /merchandises/1/edit
  def edit
  end

  # POST /merchandises
  def create
    @merchandise = current_user.merchandises.build(merchandise_params)
    if @merchandise.save 
      @merchandise.get_youtube_id
      if merchandise_params[:phase_id] == nil 
        redirect_to user_profile_path(current_user.permalink), notice: 'Patron Perk was successfully created.'
      elsif merchandise_params[:rttoeditphase].present? # I dont think this is used.
        phase = Phase.find_by_id(merchandise_params[:phase_id])
        redirect_to edit_phase_path(phase.permalink), notice: 'Patron Perk was successfully created.'
      else
        phase = Phase.find_by_id(merchandise_params[:phase_id])
          redirect_to phase_storytellerperks_path(phase.permalink), notice: 'Patron Perk was successfully created.'
      end 
    else
      render action: 'new', :notice => "Your merchandise was not saved. Check the required info (*), filetypes, or character counts."
    end
  end

  # PATCH/PUT /merchandises/1
  def update
    @merchandise = Merchandise.find(params[:id])
    if merchandise_params[:phase_id].present? && @merchandise.update(merchandise_params)
      @phase = Phase.find(@merchandise.phase_id)
      @merchandise.get_youtube_id
      redirect_to phase_standardperks_path(@phase.permalink), notice: 'Patron Perk was successfully added to phase.'
    elsif @merchandise.update(merchandise_params)
      @merchandise.get_youtube_id
      redirect_to @merchandise, notice: 'Patron Perk was successfully updated.'
    else
      render action: 'edit'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_merchandise
      @merchandise = Merchandise.find(params[:id])
      @user = User.find(@merchandise.user_id)
      if @user.phases.any?
        @sidebarphase = @user.phases.order('deadline').last 
        @sidebarmerchandise = @sidebarphase.merchandises.order(price: :asc)
      end
    end

    def merchandise_params
      params.require(:merchandise).permit(:name, :user_id, :price, :desc, :itempic, :rttoeditphase,
       :phase_id, :goal, :deadline, :youtube)
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
