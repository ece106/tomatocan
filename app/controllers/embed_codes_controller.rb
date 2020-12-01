class EmbedCodesController < ApplicationController

  # GET /embed_codes/new
  def new
    @embed_code = EmbedCode.new
  end

  # GET /embed_code
  def show
    if session[:embed_height].nil?
      redirect_to new_embed_codes_path, danger: "Error: Appropriate embed code data could not be detected in sessionStorage.\nIf this problem persists, please consider using our manual tutorial."
    end

    @fullCode = EmbedCode.generate( session[:embed_height], session[:embed_width], session[:embed_border], session[:embed_borderColor], session[:embed_borderWidth], session[:embed_position], session[:embed_bottom], session[:embed_right] )
  end

  # POST /embed_codes
  def create
    size = EmbedCode.convert_size( embed_code_params["size"] )
    session[:embed_height] = size[0]
    session[:embed_width] = size[1]

    session[:embed_border] = embed_code_params["border"]
    session[:embed_borderColor] = embed_code_params["border_color"]
    session[:embed_borderWidth] = EmbedCode.convert_border_size(embed_code_params["border_size"])

    session[:embed_position] = EmbedCode.convert_position(embed_code_params["position"])
    
    if session[:embed_position] == "default" then
      session[:embed_bottom] = -1
      session[:embed_right] = -1
    else
      location = EmbedCode.convert_location(embed_code_params["location"])
      session[:embed_bottom] = location[0]
      session[:embed_right] = location[1]
    end

    redirect_to new_embed_code_confirm_path, success: "Your code has been crafted!"
  end

  def edit
  end


  private
    # Only allow a trusted parameter "white list" through.
    def embed_code_params
      params.require(:embed_code).permit(:border, :border_color, :border_size, :size, :location, :position)
    end
end
