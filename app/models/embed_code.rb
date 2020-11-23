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


  def EmbedCode.generate(editBorder, editBorderColor, editWidth, editHeight, editBottom, editRight, editPosition, editBorderWidth)
    firstPartBasic = "<iframe src=\"https://thinq.tv/embed\" title=\"ThinQ.tv: Join in with tech industry tips!\" height=" + editHeight + " " + "width=" + editWidth

    secondPartPosition = " style=\"position: " + editPosition

    thirdPartAlignment = ""
    unless editPosition == "default" then
      thirdPartAlignment = "; z-index:99; bottom: " + editBottom.to_s + "; right: " + editRight.to_s
    end

    if editBorder == "No"
      fourthPartBorder = ";\"></iframe>"
    else
      fourthPartBorder = "; border: " + editBorderWidth + " solid " + editBorderColor  + ";\"></iframe>"
    end
    return firstPartBasic + secondPartPosition + thirdPartAlignment + fourthPartBorder
  end
  
  end
