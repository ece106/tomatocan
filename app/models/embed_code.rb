class EmbedCode

    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    attr_accessor :border, :border_color, :border_size, :size, :location, :position

    validates :location, :presence => true

    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end
  
    def persisted?
      false
    end



  def EmbedCode.convert_size( size )
    case size.downcase
      when "a small portion of the screen"
        return "200px", "400px"
      when "a decent portion of the screen"
        return "400px", "800px"
      when "a large portion of the screen"
        return "800px", "1000px"
      else
        # An unexpected option is selected.
        # Keep the values set here distinct from those of expected options to make code mistakes more noticeable & identifiable.
        return "500px", "500px"
    end
  end

  def EmbedCode.convert_border_size( border_size )
    case border_size
      when "Thin"
        return "1px"
      when "Medium"
        return "5px"
      else # "Especially Wide"
        return "10px"
    end
  end

  def EmbedCode.convert_position( position )
    case position.downcase
      when "according to where it is placed in the html file"
        return "default"
      when "in a corner of the page"
        return "absolute"
      when "in a corner of the user's screen"
        return "fixed"
      else
        raise "Error: Position option \"" + position + "\" not expected by the model."
    end
  end
  
  def EmbedCode.convert_location( location )
    case location
      when "The lower left corner"
        return 0, 1
      when "The upper left corner"
        return 1, 1
      when "The upper right corner"
        return 1, 0
      when "The lower right corner"
        return 0, 0
      else
        return -1, -1
    end
  end

  def EmbedCode.generate( embed_height, embed_width, embed_border, embed_borderColor, embed_borderWidth, embed_position, embed_bottom, embed_right )

    firstPartBasic = "<iframe src=\"https://thinq.tv/embed\" title=\"ThinQ.tv: Join in with tech industry tips!\" height=" + embed_height + " " + "width=" + embed_width

    secondPartPosition = " style=\"position: " + embed_position

    thirdPartAlignment = ""
    unless embed_position == "default" then
      thirdPartAlignment = "; z-index:99; bottom: " + embed_bottom.to_s + "; right: " + embed_right.to_s
    end

    fourthPartBorder = ";\"></iframe>"
    if embed_border.downcase == "yes"
      fourthPartBorder = "; border: " + embed_borderWidth + " solid " + embed_borderColor  + fourthPartBorder
    end

    return firstPartBasic + secondPartPosition + thirdPartAlignment + fourthPartBorder
  end

end
