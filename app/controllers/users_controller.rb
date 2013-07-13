class UsersController < ApplicationController

#  before_filter :authenticate_user!

#  before_filter :signed_in_user, only: [:index, :edit, :update]
#  before_filter :correct_user,   only: [:edit, :update]
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json 16
  def show
#    @user = User.find(params[:id])
    @user = current_user
    @books = @user.books
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1  26
  # GET /users/1.json
  def blog
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # blog.html.erb
      format.json { render json: @user }
    end
  end


  # GET /users/1  40
  # GET /users/1.json
  def profileinfo
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # profileinfo.html.erb
      format.json { render json: @user }
    end
  end


  # GET /users/1  52
  # GET /users/1.json
  def booklist
    @user = User.find(params[:id])
    @books = @user.books
    respond_to do |format|
      format.html # booklist.html.erb
      format.json { render json: @user }
    end
  end


  # GET /users/new
  # GET /users/new.json 65
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end


  # GET /users/1/edit 76
  def edit
    @user = User.find(params[:id])
    @books = @user.books
    @book = current_user.books.build # if signed_in?
    @booklist = Book.where(:user_id => @user.id)
  end


  # POST /users       
  # POST /users.json  86
  def create
    @user = User.new(params[:user])

#      if @user.save
#        sign_in @user
#        redirect_to @user
#      else
#        render 'new'
#      end
  end


  # PUT /users/1 99
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    @booklist = Book.where(:user_id => @user.id)

#    if @user.update_attributes(params[:user])
#      sign_in @user
#      redirect_to @user
#    else
#      render 'profileinfo'
#    end
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
