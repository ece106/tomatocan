  class UsersController < ApplicationController
  layout :resolve_layout

  before_action :set_user, except: [:new, :index, :authors, :create, :approveagreement, :declineagreement, :markfulfilled, :createstripeacnt, :addbankacnt, :correcterr ]
  before_action :check_fieldsneeded, except: [:update, :new, :index, :create]
  before_action :check_outstandingagreements, except: [:new, :index, :create, :approveagreement, :declineagreement, :createstripeacnt, :addbankacnt, :correcterr ]
  before_action :authenticate_user!, only: [:edit, :update, :managesales, :createstripeaccount, :addbankaccount, :correcterrors]
#  before_filter :correct_user,   only: [:edit, :update, :managesales] Why did I comment this out, was I displaying cryptic error messages
  
  def index
    userswithpic = User.where( "profilepic SIMILAR TO '%(jpg|gif|tif|png|jpeg|GIF|JPG|JPEG|TIF|PNG)'
      OR (profilepicurl SIMILAR TO 'http%' AND 
      profilepicurl SIMILAR TO '%(jpg|gif|tif|png|jpeg|GIF|JPG|JPEG|TIF|PNG)%') ")
    @users = userswithpic.paginate(:page => params[:page], :per_page => 32)
  end

  def authors
    userswithyoutube = User.where("LENGTH(youtube1) < ? AND LENGTH(youtube1) > ?", 20, 4)
    authorsvidorder = userswithyoutube.order('updated_at DESC')
    @authors = authorsvidorder.paginate(:page => params[:page], :per_page => 12)
  end

  def show
    @books = @user.books
    @numusrphs = @user.phases.count
    @numusrgroups = 0 
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
  def about
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end
  def addphasetogroup
    @agreement = Agreement.new
    @agreement.update_attribute(:group_id, params[:currgroupid]) 
    @agreement.update_attribute(:phase_id, params[:phaseid])
    redirect_to phases_path
  end

  def blog
    respond_to do |format|
      format.html # blog.html.erb
      format.json { render json: @user }
    end
  end
  def eventlist
    currtime = Time.now
    rsvps = Event.where('id IN (SELECT event_id FROM rsvpqs WHERE rsvpqs.user_id = ?)', @user.id)
    @rsvpevents = rsvps.where( "start_at > ?", currtime ) 
    @events = Event.where( "start_at > ? AND usrid = ?", currtime, @user.id )
    respond_to do |format|
      format.html 
      format.json { render json: @user }
    end
  end
  def pastevents
    currtime = Time.now
    @events = Event.where( "start_at < ? AND usrid = ?", currtime, @user.id )
    rsvps = Event.where('id IN (SELECT event_id FROM rsvpqs WHERE rsvpqs.user_id = ?)', @user.id)
    @rsvpevents = rsvps.where( "start_at < ?", currtime ) 
    respond_to do |format|
      format.html 
      format.json { render json: @user }
    end
  end
  def groups
    @groups = Group.where( "user_id = ?", @user.id )
    respond_to do |format|
      format.html 
      format.json { render json: @user }
    end
  end
  def phases
    currtime = Time.now
    @activephases = Phase.where( "user_id = ? AND deadline > ?", @user.id, currtime).order('created_at')
    @pastphases = Phase.where( "user_id = ? AND deadline < ?", @user.id, currtime).order('created_at')
    @outstandingagreements = []
    if user_signed_in?
      @mynullagreements.each do |agree|
        phase = Phase.find(agree.phase_id)
        group = Group.find(agree.group_id) 
        @outstandingagreements << {phasename: phase.name, groupname: group.name, 
        agreeid: agree.id, grouppermalink: group.permalink }
      end
    end
    respond_to do |format|
      format.html 
      format.json { render json: @user }
    end
  end
  def perks
    @perks = Merchandise.where( "user_id = ?", @user.id )
    respond_to do |format|
      format.html 
      format.json { render json: @user }
    end
  end
  def stream
    @books = @user.books
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end
  def profileinfo
#    @user.updating_password = false
    respond_to do |format|
      format.html # profileinfo.html.erb
      format.json { render json: @user }
    end
  end
  def changepassword
    respond_to do |format|
      format.html # profileinfo.html.erb
      format.json { render json: @user }
    end
  end
  def readerprofileinfo
    respond_to do |format|
      format.html # readerprofileinfo.html.erb
      format.json { render json: @user }
    end
  end
  def editbookreview
    respond_to do |format|
      format.html # editbookreview.html.erb
      format.json { render json: @user }
    end
  end
  def editauthorreview
    respond_to do |format|
      format.html # editauthorreview.html.erb
      format.json { render json: @user }
    end
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.follower.paginate(page: params[:page])
    render 'followerspage'
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'followingpage'
  end


  # GET /users/1.json
  def booklist
    @books = @user.books
    respond_to do |format|
      format.html # booklist.html.erb
      format.json { render json: @user }
    end
  end
  def movielist
    @movies = @user.movies
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
    @books = @user.books
    @book = current_user.books.build # if signed_in?
    @booklist = Book.where(:user_id => @user.id)
  end
  def movieedit
    @movies = @user.movies
    @movie = current_user.movies.build # if signed_in?
    @movielist = Movie.where(:user_id => @user.id)
  end

  def createstripeaccount #obtain legal name, countryoftax & instantiate stripe acct, stripeid
    respond_to do |format|
      format.html # profileinfo.html.erb
      format.json { render json: @user }
    end
  end
  def addbankaccount #add financial institution # to stripe acct just created
    if current_user.stripeid.present?
      account = Stripe::Account.retrieve(current_user.stripeid)
      @fieldsneeded = account.verification.fields_needed
      @countryoftax = account.country
    end
    respond_to do |format|
      format.html # profileinfo.html.erb
      format.json { render json: @user }
    end
  end
  def correcterrors
    respond_to do |format|
      format.html # profileinfo.html.erb
      format.json { render json: @user }
    end
  end
  def manageaccounts
    if current_user.stripeid.present?
      account = Stripe::Account.retrieve(current_user.stripeid)
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
      format.json { render json: @user }
    end
  end

  def createstripeacnt  #called from button on createstripeaccount page
    current_user.create_stripe_acnt(params[:countryoftax], params[:accounttype], params[:firstname], params[:lastname], 
        params[:bizname], params[:birthday], params[:birthmonth], params[:birthyear], request.remote_ip, current_user.email) 
    redirect_to user_addbankaccount_path(current_user.permalink)
  end
  def addbankacnt   #called from button on addbankaccount page
    current_user.add_bank_account(params[:currency], params[:bankaccountnumber], 
        params[:routingnumber], params[:countryofbank], params[:line1], params[:line2], 
        params[:city], params[:postal_code], params[:state], params[:ein], params[:ssn] )
    redirect_to user_profile_path(current_user.permalink)
  end
  def correcterr  #called from button on correcterror page
    current_user.correct_errors(params[:countryofbank], params[:currency], params[:routingnumber], params[:bankaccountnumber], 
        params[:countryoftax], params[:bizname], params[:accounttype], params[:firstname], 
        params[:lastname], params[:birthday], params[:birthmonth], params[:birthyear], params[:line1], 
        params[:city], params[:zip], params[:state], params[:ein], params[:ssn4], params[:fullssn]) 
    redirect_to user_profile_path(current_user.permalink)
  end
  def updatestripeacnt  #called from button on manageaccount page
    current_user.manage_account(params[:line1], params[:line2], params[:city], params[:zip], 
        params[:state], params[:email]) 
    redirect_to user_profile_path(current_user.permalink)
  end
  def approveagreement  #called from button on phase page
    current_user.approve_agreement(params[:agreeid]) 
    redirect_to user_phases_path(current_user.permalink)
  end
  def declineagreement  #called from button on phase page
    current_user.decline_agreement(params[:agreeid])  
    redirect_to user_phases_path(current_user.permalink)
  end
  def markfulfilled  #called from button on author dashboard
    current_user.mark_fulfilled(params[:purchid])  
    redirect_to user_dashboard_path(current_user.permalink)
  end

  def dashboard
    @user.calcdashboard
    @monthperkinfo = @user.monthperkinfo
    @monthbookinfo = @user.monthbookinfo
    @incomeinfo = @user.incomeinfo
    @salebyfiletype = @user.salebyfiletype
    @salebyperktype = @user.salebyperktype
    @totalinfo = @user.totalinfo
    @purchasesinfo = @user.purchasesinfo
  end

  # POST /users.json 
  def create
    @user = User.new(user_params)
#    @user.latitude = request.location.latitude #geocoder has become piece of junk
#    @user.longitude = request.location.longitude
    if @user.save
      @user.get_youtube_id
      sign_in @user
      redirect_to user_profileinfo_path(current_user.permalink)
    else
        redirect_to new_user_signup_path, danger: signup_error_message
        @user.errors.clear
    end
  end

  # PUT /users/1.json
  def update
    if @user.update_attributes(user_params)
      @user.get_youtube_id
      bypass_sign_in @user
      redirect_to user_profile_path(current_user.permalink)
    else
#      flash[:notice] = flash[:notice].to_a.concat resource.errors.full_messages
      #redirect_to user_profileinfo_path(current_user.permalink), :notice => "Your profile was not saved. Check character counts or filetype for profile picture."
        
      if params[:user][:on_password_reset] == "changepassword"
        redirect_to user_changepassword_path(current_user.permalink), danger: update_error_message
      else
        redirect_to user_profileinfo_path(current_user.permalink), danger: update_error_message
      end
      @user.errors.clear
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
        :birthday, :birthyear, :mailaddress, :countryofbank, :currency, :countryoftax, :ein, :ssn,
        :agreeid, :purchid, :bannerpic, :on_password_reset )
    end

    def resolve_layout
      case action_name
      when "index", "authors"
        'application'
      when "profileinfo", "readerprofileinfo", "managesales", "addbankaccount", "correcterrors", "createstripeaccount", "manageaccounts", "changepassword"
        'editinfotemplate'
      else
        'userpgtemplate'
      end
    end

    def check_fieldsneeded
      if user_signed_in?
        if current_user.stripeid.present? 
          account = Stripe::Account.retrieve(current_user.stripeid)
          @fieldsneeded = account.verification.fields_needed
        end
      end
    end

    def check_outstandingagreements
      if user_signed_in?
        allmyagreements = Agreement.where('phase_id IN 
        (SELECT id FROM phases WHERE phases.user_id = ?)', current_user.id)
        @mynullagreements = allmyagreements.where("approved IS NULL" )
      end
    end

    def set_user 
      @user = User.find_by_permalink(params[:permalink]) || current_user
      if @user.phases.any?
        @sidebarphase = @user.phases.order('deadline').last 
        @sidebarmerchandise = @sidebarphase.merchandises.order(price: :asc)
      end 
    end
     # returns a string of error messages for the user signup page
    def signup_error_message
       msg = ""
        if @user.errors.messages[:name].present?
          msg += ("Name " + @user.errors.messages[:name][0] + "\n")
        end
        if @user.errors.messages[:email].present?
          @user.errors.messages[:email].each do |email| 
            msg += ("Email " + email + "\n")
          end
        end
        if @user.errors.messages[:permalink].present?
          msg += ("Permalink " + @user.errors.messages[:permalink][0] + "\n")
        end
        if @user.errors.messages[:password].present?
          msg += ("Password " + @user.errors.messages[:password][0] + "\n")
        end
        
        return msg
    end

    def update_error_message
      msg = ""
      if @user.errors.messages[:name].present?
        msg += ("Name " + @user.errors.messages[:name][0] + "\n")
      end
      if @user.errors.messages[:email].present?
        msg += ("Email " + @user.errors.messages[:email][0] + "\n")
      end
      if @user.errors.messages[:permalink].present?
        msg += ("URL handle " + @user.errors.messages[:permalink][0] + "\n")
      end
      if @user.errors.messages[:password_confirmation].present?
        msg += ( "Passwords do not match \n")
      end
      if @user.errors.messages[:password].present?
        msg += ("Password " + @user.errors.messages[:password][0] + "\n")
      end
      if @user.errors.messages[:twitter].present?
        msg += ("Twitter handle " + @user.errors.messages[:twitter][0] + "\n")
      end

      return msg
    end

end

