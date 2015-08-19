class UsersController < ApplicationController
  layout :resolve_layout

  before_filter :authenticate_user!, only: [:edit, :update, :managesales, :createstripeacnt]
#  before_filter :correct_user,   only: [:edit, :update, :managesales] Why did I comment this out, was I displaying cryptic error messages
  
  def index
    picregex = /jpeg|jpg|gif|png|tif|GIF|TIF|PNG|JPEG|JPG/

    @userswithpic = User.where( "profilepic SIMILAR TO '%(jpg|gif|tif|png|jpeg|GIF|JPG|JPEG|TIF|PNG)'
      OR (profilepicurl SIMILAR TO 'http%' AND 
      profilepicurl SIMILAR TO '%(jpg|gif|tif|png|jpeg|GIF|JPG|JPEG|TIF|PNG)%') ")
    @users = @userswithpic.paginate(:page => params[:page], :per_page => 32)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end
  def show
    @user = User.find_by_permalink(params[:permalink])
#    @user = User.find(params[:id])
    @books = @user.books
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
    @events = Event.where( "start_at > ? AND usrid = ?", currtime, @user.id )
    @rsvpevents = @user.events.where( "start_at > ?", currtime )
    respond_to do |format|
      format.html 
      format.json { render json: @user }
    end
  end
  def prevevents
    currtime = Time.now
    @user = User.find_by_permalink(params[:permalink])
    @events = Event.where( "start_at < ? AND usrid = ?", currtime, @user.id )
    @rsvpevents = @user.events.where( "start_at < ?", currtime )
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
  def managesales
    @user = User.find_by_permalink(params[:permalink])
    @user.retrieve_bank_account
     respond_to do |format|
      format.html # profileinfo.html.erb
      format.json { render json: @user }
    end
  end
  def createstripeacnt
    @user = User.find_by_permalink(params[:permalink])
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

  def createbankaccount
    @user = User.find_by_permalink(params[:permalink]) || User.find(params[:id])
    @user.lastname = params[:user][:lastname]
    @user.accounttype = params[:accounttype]
    @user.create_bank_account
    @user.update_attribute(:stripeid, @user.stripeaccountid )
    redirect_to user_profile_path(current_user.permalink)
  end
  def updatebankaccount
    @user = User.find_by_permalink(params[:permalink]) || User.find(params[:id])
    account = Stripe::Account.retrieve(@user.stripeid)
#    @user.save_bank_account
    account.legal_entity.first_name = params[:user][:firstname]
    account.legal_entity.last_name = params[:user][:lastname]
    account.save
    redirect_to user_profile_path(current_user.permalink)
  end
  # PUT /users/1.json
  def update
    @user = User.find_by_permalink(params[:permalink]) || User.find(params[:id])

    unless @user.latitude
      @user.update_attribute(:latitude, request.location.latitude)
      @user.update_attribute(:longitude, request.location.longitude)
    end

    if @user.update_attributes(user_params)
      if @user.ustreamvid.match(/ustream.tv\/embed/)
        ustreamparsed = parse_ustream @user.ustreamvid
        @user.update_attribute(:ustreamvid, ustreamparsed)
      end
      if @user.youtube1.match(/youtube.com/) || @user.youtube1.match(/youtu.be/)
        youtube1parsed = parse_youtube @user.youtube1
        @user.update_attribute(:youtube1, youtube1parsed)
      end
      if @user.youtube2.match(/youtube.com/) || @user.youtube2.match(/youtu.be/)
        youtube2parsed = parse_youtube @user.youtube2
        @user.update_attribute(:youtube2, youtube2parsed)
      end
      if @user.youtube3.match(/youtube.com/) || @user.youtube3.match(/youtu.be/)
        youtube3parsed = parse_youtube @user.youtube3
        @user.update_attribute(:youtube3, youtube3parsed)
      end

      sign_in @user
    else
#      flash[:notice] = flash[:notice].to_a.concat resource.errors.full_messages
      redirect_to user_profileinfo_path(current_user.permalink), :notice => "Your profile was not saved. Check character counts or filetype for profile picture."
    end
  end

  # DELETE /users/1.json # Should replace this with a bool. No destroying users, just different status
  def destroy
    @user = User.find_by_permalink(params[:permalink])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end


  private

    def user_params
      params.require(:user).permit(:permalink, :blogtalkradio, :name, :updating_password, :email, 
        :password, :about, :author, :password_confirmation, :remember_me, :genre1, :genre2, :genre3, 
        :twitter, :ustreamvid, :ustreamsocial, :title, :blogurl, :profilepic, :profilepicurl, 
        :youtube, :pinterest, :facebook, :address, :latitude, :longitude, :youtube1, :youtube2, 
        :youtube3, :countryofbank, :videodesc1, :videodesc2, :videodesc3, :managestripeacnt, 
        :stripeid, :stripeaccountid, :firstname, :lastname, :accounttype, :birthmonth,
        :birthday, :birthyear, :mailaddress)
    end

    def resolve_layout
      case action_name
      when "index"
        'application'
      when "profileinfo", "readerprofileinfo", "createstripeacnt", "managestripeacnt"
        'editinfotemplate'
      else
        'userpgtemplate'
      end
    end

    def parse_youtube url
      regex = /(?:youtu.be\/|youtube.com\/watch\?v=|\/(?=p\/))([\w\/\-]+)/
      if url.match(regex)
        url.match(regex)[1]
      end
    end

    def parse_ustream url
      regex = /(?:.be\/|ustream.tv\/embed\/|\/(?=p\/))([\w\/\-]+)/
      if url.match(regex)
        url.match(regex)[1]
      end
    end

end

