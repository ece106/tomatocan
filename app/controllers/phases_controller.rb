class PhasesController < ApplicationController
  before_action :set_phase, only: [:patronperk, :show, :edit, :update, :destroy]
  layout :resolve_layout

  # GET /phases
  def index
    if user_signed_in?
      currentuserid = current_user.id
      currusergroups = Group.where("user_id = ?", currentuserid)
      @usrgrpnameid = []
      currusergroups.find_each do |group|
        @usrgrpnameid << [group.name, group.id] 
      end 
      @numusrgroups = currusergroups.count 
    end  
    threemonthago = Time.now - 3.months
    
    @agreedeclined=Agreement.joins(:group).where("user_id = ? AND agreements.created_at > ? 
      AND approved < ? ", currentuserid, threemonthago, '0002-01-01' )
#x = phase.where(id: Agreement.select("phase_id").where( group_id: Group.where("user_id = ?", current_user.id)) )
# x = all phases the user has already requested to affiliate with, over all of the user's groups.
# Don't want to display phases that user/group has already requested to affiliate with. However
#   if curr_user manages more than one group, all user's groups should be able to support the same phase

    #don't want 1 group to support 80 phases. 3 might be enough
#    numprojgroupsupports = Agreement.where("group_id = ?", @currgroup.id).count

    partner = []  #All phases available to be supported
    active = Phase.where("deadline > ?", Time.now)
    active.find_each do |phs|
      author = User.find(phs.user_id).name
      partner <<  {name: phs.name, creator: author, mission: phs.mission, id: phs.id,
          permalink: phs.permalink, deadline: phs.deadline, phasepic: phs.phasepic} 
    end 
    @partnerphs = partner.sort_by{|e| e[:deadline]}
  end

  # GET /phases/1
  def show
    @merchandise = @phase.merchandises.order(price: :asc)
    @author = User.find(@phase.user_id)
    @groupid = params[:groupid]
  end

  # GET /phases/new
  def new
    @phase = Phase.new
  end

  def patronperk  
    @phase = Phase.find_by_permalink(params[:permalink])
    @merchandises = @phase.merchandises
    @merchandise = @phase.merchandises.build 
    @perklist = Merchandise.where(:phase_id => @phase.id)
    dropdown1 = Merchandise.where( "user_id = ?", current_user.id).where('phase_id IS NULL')
    dropdown2 = Merchandise.where( "user_id = ?", current_user.id).where("phase_id != ?", @phase.id)
    @dropdown = dropdown1 + dropdown2
  end

  def standardperks
    @phase = phase.find_by_permalink(params[:permalink])
    @author = User.find_by_id(@phase.user_id)
    @merchandise = @phase.merchandises.build 
  end

  # GET /phases/1/edit
  def edit
    @merchandise = @phase.merchandises.order(price: :asc)
    @perklist = Merchandise.where( "user_id = ?", current_user.id)
    dropdown1 = Merchandise.where( "user_id = ?", current_user.id).where('phase_id IS NULL')
    dropdown2 = Merchandise.where( "user_id = ?", current_user.id).where("phase_id != ?", @phase.id)
    @dropdown = dropdown1 + dropdown2
    @merchandises = @phase.merchandises.build 
  end

  # POST /phases
  def create
    @phase = current_user.phases.build(phase_params)
    if @phase.save
      redirect_to phase_patronperk_path(@phase.permalink), notice: 'phase was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /phases/1
  def update
    if @phase.update(phase_params)
      redirect_to @phase, notice: 'phase was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /phases/1
  def destroy
    @phase.destroy
    redirect_to phases_url, notice: 'phase was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_phase
      if params[:id].present?
        @phase = Phase.friendly.find(params[:id])
      else
        @phase = Phase.find_by_permalink(params[:permalink])
      end
      @user = User.find(@phase.user_id)
    end

    # Only allow a trusted parameter "white list" through.
    def phase_params
      params.require(:phase).permit(:name, :user_id, :mission, :phasepic, :permalink, 
        :deadline, :currgroupid, :phaseid)
    end

    def resolve_layout
      case action_name
      when "show", "edit"
        'phasetemplate'
      else
        'application'
      end
    end
end
