class GroupsController < ApplicationController
  before_action :authenticate_user! , only: [:edit, :update, :new]
  before_action :set_group, except: [:new, :index, :create]
  before_action :set_owner, except: [:new, :index, :create]
  before_action :check_fieldsneeded, except: [:new, :index, :create]
  layout :resolve_layout

  def index
    if params[:search].present?
      if params[:dist].present? && is_number?(params[:dist])
        @groups = Group.near(params[:search], params[:dist], order: 'distance')
      else  
        @groups = Group.near(params[:search], 50, order: 'distance')
      end
#    elsif user_signed_in? && current_user.address
#      @groups = Group.near([current_user.latitude, current_user.longitude], 25, order: 'distance') 
#    elsif request.location 
#      @groups = Group.near([request.location.latitude, request.location.longitude], 25, order: 'distance') 
    else
      neargroups = Group.near([request.location.latitude, request.location.longitude], 50000, order: 'distance') 
      remaininggroups = Group.all - neargroups
      @groups = neargroups + remaininggroups
    end
  end

  def show
    currtime = Time.now
    @currprojects = []
    @group.projects.where("deadline > ?", currtime).find_each do |proj|
      approvedagreemt = Agreement.where("group_id = ? AND project_id = ?", @group.id, proj.id )
      if approvedagreemt[0].approved.present?
        if approvedagreemt[0].approved > '0002-01-01'
          author = User.find(proj.user_id)
          if proj.projectpic.present?
            picture = proj.projectpic
          else
            picture = "whiteBk.jpg"  
          end
          @currprojects <<  {pic: picture, projtitle: proj.name, authorname: author.name, desc: proj.mission, permalink: proj.permalink } 
        end
      end
    end
    @pastprojects = []
    @group.projects.where("deadline < ?", currtime).find_each do |proj|
      approvedagreemt = Agreement.where("group_id = ? AND project_id = ?", @group.id, proj.id )
      if approvedagreemt[0].approved.present?
        if approvedagreemt[0].approved > '0002-01-01'
          author = User.find(proj.user_id)
          if proj.projectpic.present?
            picture = proj.projectpic
          else
            picture = "whiteBk.jpg"  
          end
          @pastprojects <<  {pic: picture, projtitle: proj.name, authorname: author.name, desc: proj.mission, permalink: proj.permalink, authorlink: author.permalink } 
        end
      end
    end  
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
    @event_strips = @events.event_strips_for_month(@shown_month, :conditions => { :group1id => @group.id } )
    @event_strips = @events.event_strips_for_month(@shown_month, :conditions => { :group2id => @group.id } ) + @event_strips
    @event_strips = @events.event_strips_for_month(@shown_month, :conditions => { :group3id => @group.id } ) + @event_strips
  end
  def eventlist
    @events = Event.all( :conditions => { :group1id => @group.id  }) # || :group2id => @group.id || :group3id => @group.id } ) 
    @events = Event.all( :conditions => { :group2id => @group.id  }) + @events
    @events = Event.all( :conditions => { :group3id => @group.id  }) + @events
    respond_to do |format|
      format.html 
      format.json { render json: @group }
    end
  end
  def deleteevent
    @group = Group.friendly.find(params[:permalink])

    @events = Event.all( :conditions => { :group1id => @group.id  }) # || :group2id => @group.id || :group3id => @group.id } ) 
    @events = Event.all( :conditions => { :group2id => @group.id  }) + @events
    @events = Event.all( :conditions => { :group3id => @group.id  }) + @events
  end
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
    @events = Event.all( :conditions => { :group1id => @group.id  }) 
    @events = Event.all( :conditions => { :group2id => @group.id  }) + @events
    @events = Event.all( :conditions => { :group3id => @group.id  }) + @events
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

  def createstripeaccount #obtain legal name, countryoftax & instantiate stripe acct, stripeid
    respond_to do |format|
      format.html # profileinfo.html.erb
      format.json { render json: @group }
    end
  end
  def addbankaccount #add financial institution # to stripe acct just created
    if @group.stripeid.present? 
      account = Stripe::Account.retrieve(@group.stripeid)
      @countryoftax = account.country
    end  
    respond_to do |format|
      format.html # profileinfo.html.erb
      format.json { render json: @group1 }
    end
  end
  def correcterrors
    respond_to do |format|
      format.html # profileinfo.html.erb
      format.json { render json: @group }
    end
  end
  def manageaccounts
    if @group.stripeid.present? 
      account = Stripe::Account.retrieve(@group.stripeid)
      @streetaddress = account.legal_entity.address.line1
      @suite = account.legal_entity.address.line2
      @city = account.legal_entity.address.city
      @state = account.legal_entity.address.state
      @zip = account.legal_entity.address.postal_code
      @fieldsneeded = account.verification.fields_needed
      @countryoftax = account.country
      @email = account.email
    end  
    respond_to do |format|
      format.html # profileinfo.html.erb
      format.json { render json: @group }
    end
  end
  def createstripeacnt  #called from button on createstripeaccount page
    @group.create_stripe_acnt(params[:countryoftax], params[:accounttype], params[:firstname], params[:lastname], 
        params[:bizname], params[:birthday], params[:birthmonth], params[:birthyear], request.remote_ip, current_user.email) 
    redirect_to group_addbankaccount_path(@group.permalink)
  end
  def addbankacnt   #called from button on addbankaccount page
    @group.add_bank_account(params[:currency], params[:bankaccountnumber], 
        params[:routingnumber], params[:countryofbank], params[:line1], params[:line2], 
        params[:city], params[:postal_code], params[:state], params[:ein], params[:ssn] )
    redirect_to group_path(@group.permalink)
  end
  def correcterr  #called from button on correcterror page
    @group.correct_errors(params[:countryofbank], params[:currency], params[:routingnumber], params[:bankaccountnumber], 
        params[:countryoftax], params[:bizname], params[:accounttype], params[:firstname], 
        params[:lastname], params[:birthday], params[:birthmonth], params[:birthyear], 
        params[:line1], params[:city], params[:zip], params[:state], params[:ein], params[:ssn4]) 
    redirect_to group_path(@group.permalink)
  end
  def updatestripeacnt  #called from button on manageaccount page
    @group.manage_account(params[:line1], params[:line2], params[:city], params[:zip], 
        params[:state], params[:email]) 
    redirect_to group_path(@group.permalink)
  end

  def dashboard # this needs work
    @group.calcdashboard
    @monthinfo = @group.monthinfo
    @incomeinfo = @group.incomeinfo
    @filetypeinfo = @group.filetypeinfo
    @totalinfo = @group.totalinfo
    @purchasesinfo = @group.purchasesinfo
  end

  # DELETE /groups/1
  def destroy
    #create new column to flag for disabling display
    redirect_to groups_url, notice: 'Group was successfully disabled.'
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

    def check_fieldsneeded
      if @group.stripeid.present? 
        account = Stripe::Account.retrieve(@group.stripeid)
        @fieldsneeded = account.verification.fields_needed
      end
    end

    # Only allow a trusted parameter "white list" through.
    def group_params
      params.require(:group).permit( :grouptype, :name, :address, :latitude, :longitude, :user_id, :about,
        :callaction, :managestripeacnt, :grouppic, :permalink, :twitter, :newsurl,
        :stripeid, :stripeaccountid, :firstname, :lastname, :accounttype, :birthmonth,
        :birthday, :birthyear, :mailaddress, :countryofbank, :currency, :countryoftax, :ein, :ssn )
    end

    def resolve_layout
      case action_name
      when "index", "new"
        'application'
      when "edit", "show", "calendar", "eventlist", "news", "profileinfo", "readerprofileinfo", "createstripeaccount", "manageaccounts", "addbankaccount", "correcterrors"
        'grouptemplate'
      else
        'application'
      end
    end

    def is_number?(obj)
      obj.to_s == obj.to_i.to_s
    end

end
