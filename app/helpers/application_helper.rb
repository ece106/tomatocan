module ApplicationHelper
  def full_title(page_title)
    base_title = "CrowdPublish.TV"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def resource_name
    :user
  end

#I don't know why this screws up signup
#  def resource
#    @resource ||= User.new
#  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

end
