class StaticPagesController < ApplicationController
  layout :resolve_layout

  def home
    authorswithyoutube = User.where("LENGTH(youtube1) < ? AND LENGTH(youtube1) > ? AND author = ?", 20, 4, 'author')
    authorsvidorder = authorswithyoutube.order('updated_at DESC')
    @authors = authorsvidorder.paginate(:page => params[:page], :per_page => 6)

    actorswithyoutube = User.where("LENGTH(youtube1) < ? AND LENGTH(youtube1) > ? AND author = ?", 20, 4, 'actor')
    actorsvidorder = actorswithyoutube.order('updated_at DESC')
    @actors = actorsvidorder.paginate(:page => params[:page], :per_page => 6)

    if user_signed_in?
      @user = User.find(current_user.id)
      @orglink = groups_path
      @titlecaption = "Find the page for the Organization that referred you to CrowdPublish.TV"
      if @user.phases.any?
        @recentphase = @user.phases.order('deadline').last 
      end
    else
      @orglink = "/signup"
      @titlecaption = "Sign Me Up!"
    end

  end

  def howwork
  end

  private
    def static_pages_params
      params.require(:static_page).permit(:usertype )
    end

    def resolve_layout
      case action_name
      when "home"
        'homepg'
      else
        'application'
      end
    end
end
