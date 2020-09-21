module ApplicationHelper
  def retrieve_host event 
    event.user_id.nil? ? User.find(event.user_id) : User.find(event.user_id)
  end

  def render_profile_image(user)
    if !user.profilepic.nil?
      image_tag(user.profilepic.url.to_s, size: '120x120')
    end
  end

  def full_title(page_title)
    base_title = "ThinQ.tv"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def flash_class(level)
    case level
    when 'notice' then "alert alert-success"
    when 'success' then "alert alert-success"
    when 'error' then "alert alert-danger"
    when 'alert' then "alert alert-warning"
    end
  end

  # Gets the actual resource stored in the instance variable
  def resource_name
    :user
  end

  # Proxy to devise map name
  def resource
    @resource ||= User.new
  end

  # Proxy to devise map class
  def resource_class
    User
  end

  # Attempt to find the mapped route for devise based on request path
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

end
