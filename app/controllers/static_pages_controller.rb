class StaticPagesController < ApplicationController
  layout :resolve_layout

  def home
    userswithyoutube = User.where("LENGTH(youtube1) < ? AND LENGTH(youtube1) > ? AND author = ?", 20, 4, 'author')
    authorsvidorder = userswithyoutube.order('updated_at DESC')
    @authors = authorsvidorder.paginate(:page => params[:page], :per_page => 12)

    if user_signed_in?
      @orglink = groups_path
      @titlecaption = "Find the page for the Organization that referred you to CrowdPublish.TV"
    else
      @orglink = "/signup"
      @titlecaption = "Sign Me Up!"
    end

  end

  def howwork
  end

  private
    def resolve_layout
      case action_name
      when "home"
        'homepg'
      else
        'application'
      end
    end
end
