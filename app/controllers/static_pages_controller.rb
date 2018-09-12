class StaticPagesController < ApplicationController
  layout :resolve_layout

  def home
    timenotutc = Time.now - 10.hours
    @events = Event.where( "start_at > ?", timenotutc )
    userswmerch = User.joins(:merchandises).distinct
    merchorder = userswmerch.order('updated_at DESC')
    @merchusers = merchorder.paginate(:page => params[:page], :per_page => 6)
    
    if user_signed_in?
      @user = User.find(current_user.id)
    end
  end

  def faq
  end
  def suggestedperks
  end
  def aboutus
  end
  def bootcamp
  end
  def apprenticeships
  end
  def livestream
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
