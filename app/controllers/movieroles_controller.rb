class MovierolesController < ApplicationController
  before_action :set_movierole, only: [:show, :edit, :update, :destroy]

  # GET /movieroles
  def index
    @movieroles = Movierole.all
  end

  # GET /movieroles/1
  def show
  end

  # GET /movieroles/new
  def new
    @movierole = Movierole.new
  end

  # GET /movieroles/1/edit
  def edit
  end

  # POST /movieroles
  def create
    @movierole = Movierole.new(movierole_params)

    if @movierole.save
      movie=Movie.find(@movierole.movie_id)
      redirect_to movie, notice: 'Movierole was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /movieroles/1
  def update
    if @movierole.update(movierole_params)
      redirect_to @movierole, notice: 'Movierole was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /movieroles/1
  def destroy
    @movierole.destroy
    redirect_to movieroles_url, notice: 'Movierole was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movierole
      @movierole = Movierole.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def movierole_params
      params.require(:movierole).permit(:role, :roledesc, :user_id, :movie_id)
    end
end
