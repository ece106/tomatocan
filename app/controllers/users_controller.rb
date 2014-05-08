class UsersController < ApplicationController

#  before_filter :authenticate_user!
#  before_filter :signed_in_user, only: [:index, :edit, :update]
#  before_filter :correct_user,   only: [:edit, :update]
  
  def index
    @users = User.all

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


  # GET /users/1  
  # GET /users/1.json
  def profileinfo
    @user = User.find_by_permalink(params[:permalink])
#    @user.updating_password = false
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
  def orgprofileinfo
    @user = User.find_by_permalink(params[:permalink])
    respond_to do |format|
      format.html # orgprofileinfo.html.erb
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

  # GET /users/new
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
 #   @booklist = Book.where(:user_id => @user.id)

    if @user.update_attributes(user_params)
      sign_in @user
      redirect_to user_profile_path(current_user.permalink)
    else
      redirect_to user_profileinfo_path(current_user.permalink)
    end
  end

  # DELETE /users/1.json 
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
      params.require(:user).permit(:permalink, :name, :updating_password, :email, :password, :about, :author, :password_confirmation, :remember_me, :genre1, :genre2, :genre3, :twitter, :ustreamvid, :ustreamsocial, :title, :blogurl, :profilepic, :profilepicurl, :youtube, :pinterest, :facebook)
    end

=begin
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in." 
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(signin_url) unless current_user?(@user)
    end
=end

end
