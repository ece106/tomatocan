module FlashMsgHelper
  def format(errorId)
    case errorId
    when "notice"
      "success"
    when "alert"
      "danger"
    else
      errorId
    end
  end
end
