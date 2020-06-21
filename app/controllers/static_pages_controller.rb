class StaticPagesController < ApplicationController
  include ApplicationHelper

  helper_method :resource_name, :resource, :devise_mapping, :resource_class
  layout :resolve_layout

  def home
    showrecentconvo = Time.now - 10.hours
    @conversations = Event.where( "start_at > ? AND topic = ?", showrecentconvo, 'Conversation' ).order('start_at ASC').paginate(page: params[:page], :per_page => 6)
    @conversationsall = Event.where( "start_at > ? AND topic = ?", showrecentconvo, 'Conversation' )

    @events = Event.where( "start_at > ? AND (topic = ? OR topic = ?)", showrecentconvo, 'Study Hall', 'User Research' ).order('start_at ASC').paginate(page: params[:page], :per_page => 9)
    @eventsAll = Event.where( "start_at > ? AND (topic = ? OR topic = ?)", showrecentconvo, 'Study Hall', 'User Research' )
    pdtnow = Time.now - 7.hours
    pdtnext = Time.now - 8.hours
    currconvo = Event.where( "start_at < ? AND start_at > ? AND topic = ?", pdtnow, pdtnext, 'Conversation' ).first
    nextconvo = Event.where( "start_at > ? AND topic = ?", pdtnow, 'Conversation' ).order('start_at ASC').first 

    currstudy = Event.where( "start_at < ? AND start_at > ? AND (topic = ? OR topic = ?)", pdtnow, pdtnext, 'Study Hall', 'User Research' ).order('start_at ASC').first
    nextstudy = Event.where( "start_at > ? AND (topic = ? OR topic = ?)", pdtnow, 'User Research', 'Study Hall' ).order('start_at ASC').first 

    if currconvo.present?
      @displayconvo = currconvo
    else 
      @displayconvo = nextconvo
    end  
    if currstudy.present?
      @displaystudy = currstudy
    else 
      @displaystudy = nextstudy
    end  

    if @displayconvo.present?
      @name = @displayconvo.name
      @description = @displayconvo.desc
      @start_time = @displayconvo.start_at.strftime("%B %d %Y") + ' ' + @displayconvo.start_at.strftime("%T") + " PDT"
      @end_time = @displayconvo.end_at.strftime("%B %d %Y") + ' ' + @displayconvo.end_at.strftime("%T") + " PDT"
      @host = User.find(@displayconvo.usrid)
    end  
    if @displaystudy.present?
      @namestudy = @displaystudy.name
      @descriptionstudy = @displaystudy.desc
      @start_timestudy = @displaystudy.start_at.strftime("%B %d %Y") + ' ' + @displaystudy.start_at.strftime("%T") + " PDT"
      @end_timestudy = @displaystudy.end_at.strftime("%B %d %Y") + ' ' + @displaystudy.end_at.strftime("%T") + " PDT"
      @hoststudy = User.find(@displaystudy.usrid)
      @topic = @displaystudy.topic
    end  
        
    if user_signed_in?
      @user = User.find(current_user.id)
    end
  end

  def studyhall
    showrecentconvo = Time.now - 10.hours

    @events = Event.where( "start_at > ? AND (topic = ? OR topic = ?)", showrecentconvo, 'Study Hall', 'User Research' ).order('start_at ASC').paginate(page: params[:page], :per_page => 9)
    @eventsAll = Event.where( "start_at > ? AND (topic = ? OR topic = ?)", showrecentconvo, 'Study Hall', 'User Research' )
    pdtnow = Time.now - 7.hours
    pdtnext = Time.now - 8.hours

    currstudy = Event.where( "start_at < ? AND start_at > ? AND (topic = ? OR topic = ?)", pdtnow, pdtnext, 'Study Hall', 'User Research' ).order('start_at ASC').first
    nextstudy = Event.where( "start_at > ? AND (topic = ? OR topic = ?)", pdtnow, 'User Research', 'Study Hall' ).order('start_at ASC').first 

    if currstudy.present?
      @displaystudy = currstudy
    else 
      @displaystudy = nextstudy
    end  

    if @displaystudy.present?
      @namestudy = @displaystudy.name
      @descriptionstudy = @displaystudy.desc
      @start_timestudy = @displaystudy.start_at.strftime("%B %d %Y") + ' ' + @displaystudy.start_at.strftime("%T") + " PDT"
      @end_timestudy = @displaystudy.end_at.strftime("%B %d %Y") + ' ' + @displaystudy.end_at.strftime("%T") + " PDT"
      @hoststudy = User.find(@displaystudy.usrid)
    end  
        
    if user_signed_in?
      @user = User.find(current_user.id)
    end
  end

  def faq
  end
  def getinvolved
  end
  def jointheteam
  end
  def drschaeferspeaking
    @message = Message.new
  end
  def bystanderguidelines
  end
  def livestream
  end
  def vieweronhost
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

end