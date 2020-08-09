class UsersController < ApplicationController
  layout :resolve_layout

  before_action :set_user, except: [:new, :index, :supportourwork, :youtubers, :create, :stripe_callback ]
  before_action :authenticate_user!, only: [:update, :dashboard, :controlpanel ]

  #before_action :correct_user, only: [:dashboard, :user_id]
  #before_action :correct_user, only: [:controlpanel]
  #Where did this method go?

  def index
    userswithpic = User.where("profilepic SIMILAR TO '%(jpg|gif|tif|png|jpeg|GIF|JPG|JPEG|TIF|PNG)'")
    userswithpicorder = userswithpic.order('updated_at DESC')
    @users =   userswithpicorder.paginate(:page => params[:page], :per_page => 32)
  end

  def show
    # @redirecturl = "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=" + STRIPE_CONNECT_CLIENT_ID + "&scope=read_write"
    pdtnow = Time.now - 7.hours + 5.minutes
    id = @user.id
    currconvo = Event.where( "start_at < ? AND end_at > ? AND user_id = ?", pdtnow, pdtnow, id ).first
    if currconvo.present?
      @displayconvo = currconvo
    end

    currconvos = Event.where("start_at < ? AND end_at > ?", pdtnow, pdtnow)
    @otherconvos = []
    if currconvos.present?
      currconvos.each do |convo|
        if convo != @displayconvo
          @otherconvos.push(convo)
        end
      end
    end


    rsvps = Event.where('id IN (SELECT event_id FROM rsvpqs WHERE rsvpqs.user_id = ?) and start_at > ?', @user.id, pdtnow )
    @rsvpevents = rsvps.where( "start_at > ?", pdtnow)

    userid = @user.id

    upcomingevents = Event.where("start_at > ? AND user_id = ?", Time.now - 10.hours , userid).order('start_at ASC')
    @calendar_events = upcomingevents+rsvps.flat_map{ |e| e.calendar_events(e.start_at)}
    @calendar_events = @calendar_events.sort_by {|event| event.start_at}
    @calendar_events = @calendar_events.paginate(page: params[:page], :per_page => 5)

    respond_to do |format|
      format.html #show.html.erb
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
  #don't do anything right now. Need views added
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

  # GET /users/new I don't think this is used
  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit 76
  def markfulfilled  #called from button on author dashboard
    current_user.mark_fulfilled(params[:purchid])
    redirect_to user_dashboard_path(current_user.permalink)
  end

  def controlpanel
    @user.calcdashboard
    @monthperkinfo = @user.monthperkinfo
    @monthbookinfo = @user.monthbookinfo
    @incomeinfo = @user.incomeinfo
    @salebyfiletype = @user.salebyfiletype
    @salebyperktype = @user.salebyperktype
    @totalinfo = @user.totalinfo
    @purchasesinfo = @user.purchasesinfo

    currtime = Time.now
    rsvps = Event.where('id IN (SELECT event_id FROM rsvpqs WHERE rsvpqs.user_id = ?)', @user.id)
    @rsvpevents = rsvps.where( "start_at > ?", currtime )
    @events = Event.where( "start_at > ? AND user_id = ?", currtime, @user.id )
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
    @pastevents = Event.where( "start_at < ? AND user_id = ?", currtime, @user.id )
    rsvps = Event.where('id IN (SELECT event_id FROM rsvpqs WHERE rsvpqs.user_id = ?)', @user.id)
    @pastrsvps = rsvps.where( "start_at < ?", currtime )
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
    if @user.merchandises.any?
      expiredmerch = @user.merchandises.where("deadline < ?", Date.today)
      @expiredmerchandise = expiredmerch.order('deadline ASC')
    end
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

    if @user.merchandises.any?
      expiredmerch = @user.merchandises.where("deadline < ?", Date.today)
      @expiredmerchandise = expiredmerch.order('deadline ASC')
    end
  end

  def stripe_callback
    options = {
      site: 'https://connect.stripe.com',
      authorize_url: '/oauth/authorize',
      token_url: '/oauth/token'
    }
    code = params[:code]
    if Rails.env.development? || Rails.env.test?
      client = OAuth2::Client.new(STRIPE_CONNECT_CLIENT_ID, STRIPE_SECRET_KEY, options)
    else
      client = OAuth2::Client.new(ENV['STRIPE_CONNECT_CLIENT_ID'], ENV['STRIPE_SECRET_KEY'], options)
    end

    @resp = client.auth_code.get_token(code, :params => {:scope => 'read_write'})
    @access_token = @resp.token
    current_user.update!(stripeid: @resp.params["stripe_user_id"]) if @resp
    flash[:notice] = "Your account has been successfully created and is ready to process payments!"
  end

  # POST /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to new_user_session_path, success: "You have successfully signed up! An email has been sent for you to confirm your account."
      UserMailer.with(user: @user).welcome_email.deliver_later
    else
       redirect_to new_user_signup_path, danger: signup_error_message
      #redirect_to new_user_signup_path
      @user.errors.clear
    end
  end

  # PUT /users/1.json
  def update
    if @user.update_attributes(user_params)
      bypass_sign_in @user
      updateEmailMsg
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

  def facebook
    @facebook = from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |facebook|
      facebook.provider = auth.provider
      facebook.uid = auth.uid
      facebook.name = auth.info.name
      facebook.oauth_token = auth.credentials.token
      facebook.oauth_expires_at = Time.at(auth.credentials.expires_at)
      facebook.save!
    end
  end

  respond_to :js, :json, :html

  private

  def updateEmailMsg
    if params[:user][:email] != nil
      unless current_user.email.eql? params[:user][:email]
        flash[:info] = "A confirmation message for your new email has been sent to: " + params[:user][:email]
        flash[:info] += " to save changes confirm email first"
      end
    end
  end

  def user_params
    params.require(:user).permit(:permalink, :name, :email, :password,
                                 :about, :author, :password_confirmation, :genre1, :genre2, :genre3,
                                 :twitter, :title, :profilepic, :remember_me,
                                 :facebook, :youtube1, :youtube2,
                                 :youtube3, :updating_password,
                                 :agreeid, :purchid, :bannerpic, :on_password_reset, :stripesignup )
  end

  def resolve_layout
    case action_name
    when "index", "youtubers", "supportourwork", "stripe_callback"
      'application'
    when "profileinfo", "changepassword"
      'editinfotemplate'
    else
      'userpgtemplate'
    end
  end

  def set_user
    @user = User.find_by_permalink(params[:permalink]) || current_user
    if @user.merchandises.any?
      notexpiredmerch = @user.merchandises.where("deadline >= ? OR deadline IS NULL", Date.today)
      deadlineorder = notexpiredmerch.order(deadline: :asc)

      if deadlineorder.all[1].present?
        @sidebarmerchandise = deadlineorder.all[0..0] + deadlineorder.all[1..-1].sort_by(&:price)
      else
        @sidebarmerchandise = deadlineorder.all[0..0]
      end
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
      msg += ("User name " + @user.errors.messages[:permalink][0] + "\n")
    end
    if @user.errors.messages[:password].present?
      msg += ("Password " + @user.errors.messages[:password][0] + "\n")
    end
    if @user.errors.messages[:password_confirmation].present?
      msg += ("Password confirmation " + @user.errors.messages[:password_confirmation][0] + "\n")
    end

    return msg
  end

  def update_error_message
    msg = ""
    if @user.errors.messages[:name].present?
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
