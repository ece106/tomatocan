class EmbedCodesController < ApplicationController

  @@tempBorder = " "
  @@tempBorderColor = " "
  @@tempBorderWidth = " "
  @@tempWidth = " "
  @@tempHeight = " "
  @@tempBottom = -2
  @@tempRight = -2
  @@tempPosition = " "

  # GET /embed_codes/new
  def new
    @embed_code = EmbedCode.new
  end

  # GET /embed_code
  def show
    @editBorder = @@tempBorder
    @editBorderColor = @@tempBorderColor
    @editWidth = @@tempWidth 
    @editHeight = @@tempHeight 
    @editBottom = @@tempBottom 
    @editRight = @@tempRight 
    @editPosition = @@tempPosition 
    @editBorderWidth = @@tempBorderWidth
    @fullCode = "err"

    firstPartBasic = "<iframe src=\"https://thinq.tv/embed\" title=\"ThinQ.tv: Join in with tech industry tips!\" height=" + @editHeight + " " + "width=" + @editWidth

    secondPartPosition = " style = \"position: " + @editPosition

    thirdPartAlignment = ""
    unless @editPosition == "default" then
      thirdPartAlignment = "; z-index:99; bottom: " + @editBottom.to_s + "; right: " + @editRight.to_s
    end

    if @editBorder == "No"
      fourthPartBorder = "; \"></iframe>"
    else
      fourthPartBorder = "; border: " + @editBorderWidth + " solid " + @editBorderColor  + "\"></iframe>"
    end

    @fullCode = firstPartBasic + secondPartPosition + thirdPartAlignment + fourthPartBorder
  end

  # POST /embed_codes
  def create

      newHeight = ""
      newWidth = ""
      case embed_code_params["size"]
      when "A small portion of the screen"
        newHeight = "200px"
        newWidth = "400px"
      when "A decent portion of the screen"
        newHeight = "400px"
        newWidth = "800px"
      when "A large portion of the screen"
        newHeight = "800px"
        newWidth = "1000px"
      else
        newHeight = "400px"
        newWidth = "800px"
      end

      @@tempHeight = newHeight
      @@tempWidth = newWidth

      @@tempBorder = embed_code_params["border"]
      @@tempBorderColor = embed_code_params["border_color"]

      newPosition = "";
      case embed_code_params["position"]
        when "According to where it is placed in the HTML file"
          newPosition = "default"
        when "In a corner of the page"
          newPosition = "absolute"
        when "In a corner of the user's window"
          newPosition = "fixed"
        else
          raise "Error: Position option \"" + embed_code_params["position"] + "\" not expected by the controller."
      end
      @@tempPosition = newPosition

      newBottom = 0
      newRight = 1
      unless newPosition == "default" then
        case embed_code_params["location"]
        when "The lower left corner"
          newBottom = 0
          newRight = 1
        when "The upper left corner"
          newBottom = 1
          newRight = 1
        when "The upper right corner"
          newBottom = 1
          newRight = 0
        when "The lower right corner"
          newBottom = 0
          newRight = 0
        else
          newBottom = -1
          newRight = -1
        end
      end
      @@tempBottom = newBottom
      @@tempRight = newRight

      newBorderWidth = "";
      case embed_code_params["border_size"]
      when "Thin"
        newBorderWidth = "1px"
      when "Medium"
        newBorderWidth = "5px"
      else # "Especially Wide"
        newBorderWidth = "10px"
      end
      @@tempBorderWidth = newBorderWidth

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
