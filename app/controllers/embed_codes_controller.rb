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

    @fullCode = generate
  end

  # POST /embed_codes
  def create
    convert_input
    redirect_to new_embed_code_confirm_path, success: "Your code has been crafted!"
  end

  def convert_input
    case embed_code_params["size"]
      when "A small portion of the screen"
        session[:embed_height] = "200px"
        session[:embed_width] = "400px"
      when "A decent portion of the screen"
        session[:embed_height] = "400px"
        session[:embed_width] = "800px"
      when "A large portion of the screen"
        session[:embed_height] = "800px"
        session[:embed_width] = "1000px"
      else
        session[:embed_height] = "400px"
        session[:embed_width] = "800px"
    end

    session[:embed_border] = embed_code_params["border"]
    session[:embed_borderColor] = embed_code_params["border_color"]

    case embed_code_params["border_size"]
      when "Thin"
        session[:embed_borderWidth] = "1px"
      when "Medium"
        session[:embed_borderWidth] = "5px"
      else # "Especially Wide"
        session[:embed_borderWidth] = "10px"
    end

    case embed_code_params["position"]
      when "according to where it is placed in the HTML file"
        session[:embed_position] = "default"
      when "in a corner of the page"
        session[:embed_position] = "absolute"
      when "in a corner of the user's screen"
        session[:embed_position] = "fixed"
      else
        raise "Error: Position option \"" + embed_code_params["position"] + "\" not expected by the controller."
    end

    unless session[:embed_position] == "default" then
      case embed_code_params["location_input"]
        when "The lower left corner"
          session[:embed_bottom] = 0
          session[:embed_right] = 1
        when "The upper left corner"
          session[:embed_bottom] = 1
          session[:embed_right] = 1
        when "The upper right corner"
          session[:embed_bottom] = 1
          session[:embed_right] = 0
        when "The lower right corner"
          session[:embed_bottom] = 0
          session[:embed_right] = 0
        else
          session[:embed_bottom] = -1
          session[:embed_right] = -1
      end
    end
  end

  def generate

    firstPartBasic = "<iframe src=\"https://thinq.tv/embed\" title=\"ThinQ.tv: Join in with tech industry tips!\" height=" + session[:embed_height] + " " + "width=" + session[:embed_width]

    secondPartPosition = " style=\"position: " + session[:embed_position]

    thirdPartAlignment = ""
    unless session[:embed_position] == "default" then
      thirdPartAlignment = "; z-index:99; bottom: " + session[:embed_bottom].to_s + "; right: " + session[:embed_right].to_s
    end

    fourthPartBorder = ";\"></iframe>"
    if session[:embed_border].downcase == "yes"
      fourthPartBorder = "; border: " + session[:embed_borderWidth] + " solid " + session[:embed_borderColor]  + fourthPartBorder
    end

    return firstPartBasic + secondPartPosition + thirdPartAlignment + fourthPartBorder
  end

  def edit
  end

  private
    # Only allow a trusted parameter "white list" through.
    def embed_code_params
      params.require(:embed_code).permit(:border, :border_color, :border_size, :size, :location, :position)
    end
end
