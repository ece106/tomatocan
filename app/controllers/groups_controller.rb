class GroupsController < ApplicationController
  before_action :authenticate_user! , except: [:index, :show]
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  layout :resolve_layout

  def index
    @groups = Group.all
    if params[:search].present?
      @groups = Group.near(params[:search], params[:dist], order: 'distance')
    elsif user_signed_in? && current_user.address
      @groups = Group.near([current_user.latitude, current_user.longitude], 25, order: 'distance') 
    else
      @groups = Group.near([request.location.latitude, request.location.longitude], 25, order: 'distance')
    end
  end

  def show
    @user = User.find(@group.user_id)
  end

  def blog
    respond_to do |format|
      format.html # blog.html.erb
      format.json { render json: @group }
    end
  end
  def calendar
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i
    @shown_month = Date.civil(@year, @month)
    @events = Event.all 
    @event_strips = @events.event_strips_for_month(@shown_month, :conditions => { :group_id => @group.id } ) 
  end
  def eventlist
    @events = Event.all( :conditions => { :user_id => @group.id } ) 
    respond_to do |format|
      format.html 
      format.json { render json: @group }
    end
  end
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
    @group.slug = nil
    @group.save!
  end

  # POST /groups
  def create
    @group = current_user.groups.build(group_params)

    if @group.save
      redirect_to @group
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /groups/1
  def update
    if @group.update(group_params)
      redirect_to @group
    else
      render action: 'edit'
    end
  end

  # DELETE /groups/1
  def destroy
    @group.destroy
    redirect_to groups_url, notice: 'Group was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.friendly.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def group_params
      params.require(:group).permit( :grouptype, :name, :address, :latitude, :longitude, :user_id, :about, :grouppic, :permalink )
    end

    def resolve_layout
      case action_name
      when "index"
        'application'
      when "edit"
        'grouptemplate'
      else
        'grouptemplate'
      end
    end

end
