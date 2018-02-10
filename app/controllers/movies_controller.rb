class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  layout :resolve_layout

  def index # This will be a result of some filters
#    @movies = movie.joins(:user).where("stripeid IS NOT NULL")
    @movies = Movie.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def create
    @movie = current_user.movies.build(movie_params)
    if @movie.save
      if @movie.youtube1.match(/youtube.com/) || @movie.youtube1.match(/youtu.be/)
        youtube1parsed = parse_youtube @movie.youtube1
        @movie.update_attribute(:youtube1, youtube1parsed)
      end
      if @movie.youtube2.match(/youtube.com/) || @movie.youtube2.match(/youtu.be/)
        youtube2parsed = parse_youtube @movie.youtube2
        @movie.update_attribute(:youtube2, youtube2parsed)
      end
      if @movie.youtube3.match(/youtube.com/) || @movie.youtube3.match(/youtu.be/)
        youtube3parsed = parse_youtube @movie.youtube3
        @movie.update_attribute(:youtube1, youtube3parsed)
      end
      redirect_to user_profile_path(current_user.permalink)
    else
      redirect_to user_edit_path(current_user.permalink), :notice => "Your movie was not saved. Check the required info (*), filetypes, or character counts."
    end
  end

  def update
    @movie = Movie.find(params[:id])
    if @movie.update_attributes(movie_params)
      if @movie.youtube1.match(/youtube.com/) || @movie.youtube1.match(/youtu.be/)
        youtube1parsed = parse_youtube @movie.youtube1
        @movie.update_attribute(:youtube1, youtube1parsed)
      end
      if @movie.youtube2.match(/youtube.com/) || @movie.youtube2.match(/youtu.be/)
        youtube2parsed = parse_youtube @movie.youtube2
        @movie.update_attribute(:youtube2, youtube2parsed)
      end
      if @movie.youtube3.match(/youtube.com/) || @movie.youtube3.match(/youtu.be/)
        youtube3parsed = parse_youtube @movie.youtube3
        @movie.update_attribute(:youtube1, youtube3parsed)
      end
      redirect_to user_profile_path(current_user.permalink)
    else
      redirect_to user_edit_path(current_user.permalink), :notice => "Your movie was not saved. Check the required info (*), filetypes, or character counts."
    end
  end

  def edit
    @movie = Movie.find(params[:id])
    @user = User.find(@movie.user_id)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movie }
    end
  end

  def show
    @movie = Movie.find(params[:id])
    @user = User.find(@movie.user_id)

    castmembers = User.where('id IN 
        (SELECT user_id FROM movieroles WHERE movieroles.movie_id = ?)', @movie.id)
    roles = Movierole.where("movie_id = ?", @movie.id)
    @castlist = []
    roles.each do |role|
      actor = User.find(role.user_id) 
      @castlist << {name: actor.name, char: role.role, chardesc: role.roledesc, permalink: actor.permalink}
    end

    if user_signed_in?
      if Movierole.where("user_id = ? AND movie_id = ?", @user.id, @movie.id).empty?
        @incast = false
      else 
        @incast = true
      end  
    end  

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movie }
    end
  end

  def destroy
    @movie.destroy
    redirect_to user_path(@user.permalink), notice: 'movie was successfully deleted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_movie
      @movie = Movie.find(params[:id])
      @user = User.find(@movie.user_id)
      if @user.phases.any?
        @sidebarphase = @user.phases.order('deadline').last 
        @sidebarmerchandise = @sidebarphase.merchandises.order(price: :asc)
      end
    end

    def movie_params
      params.require(:movie).permit( :moviepic, :title, :about, :genre, :price, 
        :user_id, :youtube1, :youtube2, :youtube3, :videodesc1, :videodesc2, 
        :videodesc3, :director )
    end

    def parse_youtube url
      regex = /(?:youtu.be\/|youtube.com\/watch\?v=|youtube.com\/embed\/|\/(?=p\/))([\w\/\-]+)/
      if url.match(regex)
        url.match(regex)[1]
      end
    end
  
    def resolve_layout
      case action_name
      when "show"
        'userpgtemplate'
      else
        'application'
      end
    end
end