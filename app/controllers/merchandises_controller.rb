class MerchandisesController < ApplicationController
  before_action :set_merchandise, only: [:show, :edit, :update, :destroy]

  # GET /merchandises
  def index
    @merchandises = Merchandise.all
  end

  # GET /merchandises/1
  def show
  end

  # GET /merchandises/new
  def new
    @merchandise = Merchandise.new
  end

  # GET /merchandises/1/edit
  def edit
  end

  # POST /merchandises
  def create
    @merchandise = current_user.merchandises.build(merchandise_params)

    if @merchandise.save
      redirect_to new_merchandise_path, notice: 'Reward was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /merchandises/1
  def update
    if @merchandise.update(merchandise_params)
      redirect_to @merchandise, notice: 'Merchandise was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /merchandises/1
  def destroy
    @merchandise.destroy
    redirect_to merchandises_url, notice: 'Merchandise was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_merchandise
      @merchandise = Merchandise.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def merchandise_params
      params.require(:merchandise).permit(:name, :user_id, :price, :desc, :itempic)
    end
end
