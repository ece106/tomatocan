class GroupsController < ApplicationController
  before_action :authenticate_user! , only: [:edit, :update, :new]
  before_action :set_group, except: [:new, :index, :create]
  before_action :set_owner, except: [:new, :index, :create]
  # before_action :check_fieldsneeded, except: [:new, :index, :create]
  layout :resolve_layout

  def index
    if params[:search].present?
      if params[:dist].present? && is_number?(params[:dist])
        @groups = Group.near(params[:search], params[:dist], order: 'distance').order('updated_at DESC')
      else  
        @groups = Group.near(params[:search], 50, order: 'distance').order('updated_at DESC')
      end
#    elsif user_signed_in? && current_user.address
#      @groups = Group.near([current_user.latitude, current_user.longitude], 25, order: 'distance') 
#    elsif request.location 
#      @groups = Group.near([request.location.latitude, request.location.longitude], 25, order: 'distance') 
    else
      #neargroups = Group.near([request.location.latitude, request.location.longitude], 50000, order: 'distance') 
      #remaininggroups = Group.all - neargroups
      @groups = Group.all.order('updated_at DESC')
    end
  end

  def show 
  end

  def news
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
    @event_strips = @events.event_strips_for_month(@shown_month).where('group1id = ?', @group.id )
    @event_strips = @events.event_strips_for_month(@shown_month).where('group2id = ?', @group.id ) + @event_strips
    @event_strips = @events.event_strips_for_month(@shown_month).where('group3id = ?', @group.id ) + @event_strips
  end


  def eventlist
    @events = Event.where('group1id = ?', @group.id )
    @events = Event.where('group2id = ?', @group.id ) + @events
    @events = Event.where('group3id = ?', @group.id ) + @events
    respond_to do |format|
      format.html 
      format.json { render json: @group }
    end
  end
  def deleteevent
    @group = Group.friendly.find(params[:permalink])

    @events = Event.where('group1id = ?', @group.id ) # || :group2id => @group.id || :group3id => @group.id } ) 
    @events = Event.where('group2id = ?', @group.id ) + @events
    @events = Event.where('group3id = ?', @group.id ) + @events
  end
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
    @events = Event.where('group1id = ?', @group.id ) 
    @events = Event.where('group2id = ?', @group.id ) + @events
    @events = Event.where('group3id = ?', @group.id ) + @events
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
      @group.slug = nil
      @group.save!
      redirect_to @group
    else
      render action: 'edit'
    end
  end

  def dashboard # this needs work
    @group.calcdashboard
    @incomeinfo = @group.incomeinfo
    @totalinfo = @group.totalinfo
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      if params[:id].present?
        @group = Group.friendly.find(params[:id])
      else  
        @group = Group.find_by_permalink(params[:permalink])
      end
    end

    def set_owner 
      @user = User.find(@group.user_id)
    end

    # Only allow a trusted parameter "white list" through.
    def group_params
      params.require(:group).permit( :grouptype, :name, :address, :latitude, :longitude, :user_id, :about,
        :callaction, :grouppic, :permalink, :twitter, :newsurl, :slug )
    end

    def resolve_layout
      case action_name
      when "index", "new"
        'application'
      when "edit", "show", "calendar", "eventlist", "news", "profileinfo", "readerprofileinfo", 
        "dashboard", 'grouptemplate'
      else
        'application'
      end
    end

    def is_number?(obj)
      obj.to_s == obj.to_i.to_s
    end

end
