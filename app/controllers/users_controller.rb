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
    @user = User.find_by_permalink(params[:id])
  #  @user = User.find(params[:id])
  #  @user = current_user
    @books = @user.books
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  def blog
    @user = User.find_by_permalink(params[:id])

    respond_to do |format|
      format.html # blog.html.erb
      format.json { render json: @user }
    end
  end


  # GET /users/1  40
  # GET /users/1.json
  def profileinfo
    @user = User.find_by_permalink(params[:id])
    respond_to do |format|
      format.html # profileinfo.html.erb
      format.json { render json: @user }
    end
  end
  def readerprofileinfo
    @user = User.find_by_permalink(params[:id])
    respond_to do |format|
      format.html # readerprofileinfo.html.erb
      format.json { render json: @user }
    end
  end
  def orgprofileinfo
    @user = User.find_by_permalink(params[:id])
    respond_to do |format|
      format.html # orgprofileinfo.html.erb
      format.json { render json: @user }
    end
  end
  def editbookreview
    @user = User.find_by_permalink(params[:id])
    respond_to do |format|
      format.html # editbookreview.html.erb
      format.json { render json: @user }
    end
  end
  def editauthorreview
    @user = User.find_by_permalink(params[:id])
    respond_to do |format|
      format.html # editauthorreview.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1.json
  def booklist
    @user = User.find_by_permalink(params[:id])
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
    @user = User.find_by_permalink(params[:id])
    @books = @user.books
    @book = current_user.books.build # if signed_in?
    @booklist = Book.where(:user_id => @user.id)
  end


  # POST /users       
  # POST /users.json  86
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to @user
    else
      render 'sign_in'
    end
  end


  # PUT /users/1 99
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    @booklist = Book.where(:user_id => @user.id)

    if @user.update_attributes(params[:user])
      sign_in @user
      redirect_to @user
    else
      render 'profileinfo'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json 
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end


  private

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
