module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    html = <<-HTML
    <div id="error_explanation">
      <h2>#{sentence}</h2>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  def devise_error_messages?
   !resource.errors.empty?
  end

  def showDeviseErrors
    unless resource.errors.empty?
      errorMsg = resource.errors.full_messages.join("<br>")
      html = <<-HTML
      <div class='alert alert-danger' role='alert'>
        #{errorMsg}
      </div>
      HTML
      return html.html_safe
    end
    return ""
  end
end
