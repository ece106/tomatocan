class CalendarController < ApplicationController
#  before_filter :authenticate_user!, :except => [:index]
  
  def index
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i
    @shown_month = Date.civil(@year, @month)

    @events = Event.all
    if params[:search].present?
      @events = Event.near(params[:search], params[:dist]) 
    elsif user_signed_in?
      @groups = Event.near([current_user.latitude, current_user.longitude], 25, order: 'distance') 
    else
      @groups = Event.near(request.location, 25, order: 'distance')
      # Event where address = "online"
    end

#    @event_strips = Event.event_strips_for_month(@shown_month, :include => :some_relation, :conditions => 'some_relations.some_column = true')
    @event_strips = @events.event_strips_for_month(@shown_month) 

  end
end
