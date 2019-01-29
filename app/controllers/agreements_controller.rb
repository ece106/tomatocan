class AgreementsController < ApplicationController
  before_action :set_agreement, only: [:show, :edit, :update, :destroy]

  # GET /agreements
  def index
    @agreements = Agreement.all
  end

  # GET /agreements/1
  def show
  end

  # POST /agreements
  def create
    @agreement = Agreement.new(agreement_params)
    if @agreement.save
      redirect_to phase_path(@agreement.phase_id), notice: 'Partnership request was sent.'
    else
      redirect_to phase_path(@agreement.phase_id), notice: 'Partnership request was not valid.'
    end
  end

  # PATCH/PUT /agreements/1
  def update
    if @agreement.update(agreement_params)
      redirect_to phase_path(@agreement.phase_id), notice: 'Partnership was updated.'
    else
         redirect_to phase_path(@agreement.phase_id), notice: 'Partnership was updated.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agreement
      @agreement = Agreement.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def agreement_params
      params.require(:agreement).permit(:phase_id, :group_id)
    end
end
