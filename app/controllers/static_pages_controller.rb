class StaticPagesController < ApplicationController
  layout :resolve_layout

  def home
    storytellerswithyoutube = User.where("LENGTH(youtube1) < ? AND LENGTH(youtube1) > ? AND author = ?", 20, 4, 'author')
    storytellersvidorder = storytellerswithyoutube.order('updated_at DESC')
    @authors = storytellersvidorder.paginate(:page => params[:page], :per_page => 6)

    campaignswithpic = Phase.where( "phasepic SIMILAR TO '%(jpg|gif|tif|png|jpeg|GIF|JPG|JPEG|TIF|PNG)'")
    campaignvidorder = campaignswithpic.order('updated_at DESC')
    @campaigns = campaignvidorder.paginate(:page => params[:page], :per_page => 6)

    if user_signed_in?
      @user = User.find(current_user.id)
      @orglink = groups_path
      @titlecaption = "Find the page for the Organization that referred you to CrowdPublish.TV"
      if @user.phases.any?
        @recentphase = @user.phases.order('deadline').last 
        if current_user.author == "author"
          @perkpath = phase_authorperks_path(@recentphase.permalink)
        else
          @perkpath = phase_actorperks_path(@recentphase.permalink)
        end
      end
    else
      @orglink = "/signup"
      @titlecaption = "Sign Me Up!"
    end
  end

  def faq
  end
  def suggestedperks
  end
  def aboutus
  end

  def tellfriends
    if user_signed_in?
      @user = User.find(current_user.id)
    end
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
