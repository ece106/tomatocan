class EmbedLinksController < ApplicationController
  before_action :set_embed_link, only: [:show, :edit, :update, :destroy]

  # GET /embed_links
  def index
    @embed_links = EmbedLink.all
  end

  # GET /embed_links/1
  def show
  end

  # GET /embed_links/new
  def new
    @embed_link = EmbedLink.new
  end

  # GET /embed_links/1/edit
  def edit
  end

  # POST /embed_links
  def create
    @embed_link = EmbedLink.new(embed_link_params)

    if @embed_link.save
      redirect_to @embed_link, notice: 'Embed link was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /embed_links/1
  def update
    if @embed_link.update(embed_link_params)
      redirect_to @embed_link, notice: 'Embed link was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /embed_links/1
  def destroy
    @embed_link.destroy
    redirect_to embed_links_url, notice: 'Embed link was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_embed_link
      @embed_link = EmbedLink.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def embed_link_params
      params.require(:embed_link).permit(:border, :border_color, :border_size, :size, :location, :special_position)
    end
end
