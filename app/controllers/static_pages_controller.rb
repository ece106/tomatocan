class StaticPagesController < ApplicationController
  include ApplicationHelper

  helper_method :resource_name, :resource, :devise_mapping, :resource_class

  # before_action :set_upcoming_events, only: [:home]

  layout :resolve_layout

  def home
    timenotutc = Time.now - 9.hours
    @events = Event.where( "start_at > ?", timenotutc ).order('start_at ASC').paginate(page: params[:page], :per_page => 6)
    mstnow = Time.now - 7.hours
    @currconvo = Event.where( "start_at < ? AND end_at > ?", mstnow, mstnow ).first

    if @currconvo.present?
      @name = @currconvo.name
      @description = @currconvo.desc
      @start_time = @currconvo.start_at.strftime("%B %d %Y") + ' ' + @currconvo.start_at.strftime("%T") + " PDT"
      @end_time = @currconvo.end_at.strftime("%B %d %Y") + ' ' + @currconvo.end_at.strftime("%T") + " PDT"
      @host = User.find(@currconvo.usrid)
    else
      @name = @events.first.name
      @description = @events.first.desc
      @start_time = @events.first.start_at.strftime("%B %d %Y") + ' ' + @events.first.start_at.strftime("%T") + " PDT"
      @end_time = @events.first.end_at.strftime("%B %d %Y") + ' ' + @events.first.end_at.strftime("%T") + " PDT"
      @host = User.find(@events.first.usrid)  
    end  

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
  def livestream
  end

  def tellfriends
    #The current content on this page should be integrated into some page that helps hosts set up shows
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

  # def set_upcoming_events
  #   # @events = Event.all
  #   timenotutc = Time.now - 10.hours
  #   @events = Event.where("start_at > ?", timenotutc).order('start_at ASC')

  #   @sunday_events    = []
  #   @monday_events    = []
  #   @tuesday_events   = []
  #   @wednesday_events = []
  #   @thursday_events  = []
  #   @friday_events    = []
  #   @saturday_events  = []

  #   @events.each do |event|
  #     if event.start_at.strftime("%A") == "Sunday"
  #       @sunday_events.push(event)
  #     elsif event.start_at.strftime("%A") == "Monday"
  #       @monday_events.push(event)
  #     elsif event.start_at.strftime("%A") == "Tuesday"
  #       @tuesday_events.push(event)
  #     elsif event.start_at.strftime("%A") == "Wednesday"
  #       @wednesday_events.push(event)
  #     elsif event.start_at.strftime("%A") == "Thursday"
  #       @thursday_events.push(event)
  #     elsif event.start_at.strftime("%A") == "Friday"
  #       @friday_events.push(event)
  #     elsif event.start_at.strftime("%A") == "Saturday"
  #       @saturday_events.push(event)
  #     end
  #   end
  # end

end
