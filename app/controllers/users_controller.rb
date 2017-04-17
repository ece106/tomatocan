class UsersController < ApplicationController
  layout :resolve_layout

  before_filter :authenticate_user!, only: [:edit, :update, :managesales, :createstripeaccount, :addbankaccount]
#  before_filter :correct_user,   only: [:edit, :update, :managesales] Why did I comment this out, was I displaying cryptic error messages
  
  def index
    userswithpic = User.where( "profilepic SIMILAR TO '%(jpg|gif|tif|png|jpeg|GIF|JPG|JPEG|TIF|PNG)'
      OR (profilepicurl SIMILAR TO 'http%' AND 
      profilepicurl SIMILAR TO '%(jpg|gif|tif|png|jpeg|GIF|JPG|JPEG|TIF|PNG)%') ")
    @users = userswithpic.paginate(:page => params[:page], :per_page => 32)
  end

  def show
    @user = User.find_by_permalink(params[:permalink])
#    @user = User.find(params[:id])
    @books = @user.books
    @project = @user.projects.order('created_at').last #do i want all projects that havent met deadline

    if user_signed_in?
      currusergroups = Group.where("user_id = ?", current_user.id)
      @usrgrpnameid = []
      currusergroups.find_each do |group|
        @usrgrpnameid <<  [group.name, group.id] 
      end 
      @numusrgroups = currusergroups.count 
    end 

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end
  def addprojecttogroup
    @agreement = Agreement.new
    @agreement.update_attribute(:group_id, params[:currgroupid]) 
    @agreement.update_attribute(:project_id, params[:projectid])
    redirect_to projects_path
  end

  def pastprojects
    @user = User.find_by_permalink(params[:permalink])
#    @user = User.find(params[:id])
    @projects = @user.projects.sort! { |a, b| a.created_at <=> b.created_at }

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end
  def blog
    @user = User.find_by_permalink(params[:permalink])
    respond_to do |format|
      format.html # blog.html.erb
      format.json { render json: @user }
    end
  end
  def calendar
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i
    @shown_month = Date.civil(@year, @month)
    @user = User.find_by_permalink(params[:permalink])
    @events = Event.all 
    @event_strips = @events.event_strips_for_month(@shown_month, :conditions => { :usrid => @user.id } ) 
  end
  def eventlist
    currtime = Time.now
    @user = User.find_by_permalink(params[:permalink])
    rsvps = Event.where('id IN (SELECT event_id FROM rsvpqs WHERE rsvpqs.user_id = ?)', @user.id)
    @rsvpevents = rsvps.where( "start_at > ?", currtime ) 
    @events = Event.where( "start_at > ? AND usrid = ?", currtime, @user.id )
    respond_to do |format|
      format.html 
      format.json { render json: @user }
    end
  end
  def prevevents
    currtime = Time.now
    @user = User.find_by_permalink(params[:permalink])
    @events = Event.where( "start_at < ? AND usrid = ?", currtime, @user.id )
    rsvps = Event.where('id IN (SELECT event_id FROM rsvpqs WHERE rsvpqs.user_id = ?)', @user.id)
    @rsvpevents = rsvps.where( "start_at < ?", currtime ) 
    respond_to do |format|
      format.html 
      format.json { render json: @user }
    end
  end
  def groups
    @user = User.find_by_permalink(params[:permalink])
    @groups = Group.where( "user_id = ?", @user.id )
    respond_to do |format|
      format.html 
      format.json { render json: @user }
    end
  end
  def projects
    @user = User.find_by_permalink(params[:permalink])
    @projects = Project.where( "user_id = ?", @user.id ).order('created_at')
    respond_to do |format|
      format.html 
      format.json { render json: @user }
    end
  end
  def loot
    @user = User.find_by_permalink(params[:permalink])
    @loot = Merchandise.where( "user_id = ?", @user.id )
    respond_to do |format|
      format.html 
      format.json { render json: @user }
    end
  end
  def stream
    @user = User.find_by_permalink(params[:permalink])
    @books = @user.books
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end
  def profileinfo
    @user = User.find_by_permalink(params[:permalink])
#    @user.updating_password = false
    respond_to do |format|
      format.html # profileinfo.html.erb
      format.json { render json: @user }
    end
  end
  def manageaccounts
    @user = User.find_by_permalink(params[:permalink])
    account = Stripe::Account.retrieve(@user.stripeid)
    @countryoftax = account.country
     respond_to do |format|
      format.html # profileinfo.html.erb
      format.json { render json: @user }
    end
  end
  def readerprofileinfo
    @user = User.find_by_permalink(params[:permalink])
    respond_to do |format|
      format.html # readerprofileinfo.html.erb
      format.json { render json: @user }
    end
  end
  def editbookreview
    @user = User.find_by_permalink(params[:permalink])
    respond_to do |format|
      format.html # editbookreview.html.erb
      format.json { render json: @user }
    end
  end
  def editauthorreview
    @user = User.find_by_permalink(params[:permalink])
    respond_to do |format|
      format.html # editauthorreview.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1.json
  def booklist
    @user = User.find_by_permalink(params[:permalink])
    @books = @user.books
    respond_to do |format|
      format.html # booklist.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new I don't think this is used
  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit 76
  def edit
    @user = User.find_by_permalink(params[:permalink])
    @books = @user.books
    @book = current_user.books.build # if signed_in?
    @booklist = Book.where(:user_id => @user.id)
  end

  def addbankaccount #add financial institution # to stripe acct just created
    @user = User.find_by_permalink(params[:permalink])
    @account = Stripe::Account.retrieve(@user.stripeid)
    @countryoftax = @account.country
     respond_to do |format|
      format.html # profileinfo.html.erb
      format.json { render json: @user }
    end
  end
  def createstripeaccount #obtain legal name, countryoftax & instantiate stripe acct, stripeid
    @user = User.find_by_permalink(params[:permalink])
    respond_to do |format|
      format.html # profileinfo.html.erb
      format.json { render json: @user }
    end
  end
  def createstripeacnt  #called from button on createstripeaccount page
    @user = User.find_by_permalink(params[:permalink]) || User.find(params[:id])
    current_user.createstripeacnt(params[:countryoftax], params[:accounttype], params[:firstname], params[:lastname], 
                          params[:birthday], params[:birthmonth], params[:birthyear], request.remote_ip) 
    redirect_to user_addbankaccount_path(current_user.permalink)
  end
  def updatestripeacnt
    # need to make it so people can enter a new bank acct if they change
  end
  def dashboard
    @user = User.find_by_permalink(params[:permalink]) || User.find(params[:id])
    usr = current_user
    @user.calcdashboard(usr)
    @monthinfo = @user.monthinfo
    @incomeinfo = @user.incomeinfo
    @filetypeinfo = @user.filetypeinfo
    @totalinfo = @user.totalinfo
    @purchasesinfo = @user.purchasesinfo
  end

  def addbankacnt   #called from button on addbankaccount page
    @user = User.find_by_permalink(params[:permalink]) || User.find(params[:id])
#    account = Stripe::Account.retrieve(@user.stripeid)
    @user.add_bank_account(params[:currency], params[:bankaccountnumber], 
          params[:routingnumber], params[:countryofbank], params[:line1], params[:line2], 
          params[:city], params[:postal_code], params[:state])
    redirect_to user_profile_path(current_user.permalink)
  end
  # POST /users.json 
  def create
    @user = User.new(user_params)
#    @user.latitude = request.location.latitude
#    @user.longitude = request.location.longitude

    if @user.save
      sign_in @user
      redirect_to user_profile_path(current_user.permalink)
    else
      render 'signup'
    end
  end
  # PUT /users/1.json
  def update
    @user = User.find_by_permalink(params[:permalink]) || User.find(params[:id])
    if @user.latitude.present?
      unless @user.latitude.is_a?(Numeric)  #put this in the model and make a method call? Should method be called after attribs updated?
        loc = request.location
        if loc.present?
          @user.update_attribute(:latitude, loc.latitude)
          @user.update_attribute(:longitude, loc.longitude)
        end
      end
    else
      begin
        loc = request.location
        lat = loc.latitude
        lon = loc.longitude
      rescue Errno::EHOSTUNREACH, Errno::ETIMEDOUT, Errno::ENETUNREACH, Geocoder::NetworkError
        # primary service unreachable, try secondary...
        _page = Net::HTTP.get(URI('https://geoip-db.com/json/geoip.php'))
        lat = JSON.parse(_page)['latitude'].to_f
        puts "RESCUE"
        puts lat
        lon = JSON.parse(_page)['longitude'].to_f
        # I'm pretty sure none of this is happening since most new signups still do not have a lat lon
        # Also, this supposedly will give the address of heroku's servers in Ashburn
      end
      
      if lat.present?
        @user.update_attribute(:latitude, lat)
      end
      if lon.present?
        @user.update_attribute(:longitude, lon)
      end
    end

    if @user.update_attributes(user_params)
      @user.get_youtube_id
      sign_in @user
      redirect_to user_profile_path(current_user.permalink)
    else
#      flash[:notice] = flash[:notice].to_a.concat resource.errors.full_messages
      redirect_to user_profileinfo_path(current_user.permalink), :notice => "Your profile was not saved. Check character counts or filetype for profile picture."
    end  
  end


  private

    def user_params
      params.require(:user).permit(:permalink, :blogtalkradio, :name, :updating_password, :email, 
        :password, :about, :author, :password_confirmation, :remember_me, :genre1, :genre2, :genre3, 
        :twitter, :ustreamsocial, :title, :blogurl, :profilepic, :profilepicurl, 
        :youtube, :pinterest, :facebook, :address, :latitude, :longitude, :youtube1, :youtube2, 
        :youtube3, :videodesc1, :videodesc2, :videodesc3, :managestripeacnt, 
        :stripeid, :stripeaccountid, :firstname, :lastname, :accounttype, :birthmonth,
        :birthday, :birthyear, :mailaddress, :countryofbank, :currency, :countryoftax)
    end

    def resolve_layout
      case action_name
      when "index"
        'application'
      when "profileinfo", "readerprofileinfo", "createstripeaccount", "managesales", "addbankaccount"
        'editinfotemplate'
      else
        'userpgtemplate'
      end
    end

end

