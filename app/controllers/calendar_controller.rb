class CalendarController < ApplicationController
  
  def index
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i
    @shown_month = Date.civil(@year, @month)

    @events = Event.all
    if params[:search].present?
      if params[:dist].present? && is_number?(params[:dist])
        @events = Event.near(params[:search], params[:dist]) 
      else
        @events = Event.near(params[:search], 50) 
      end
#    elsif user_signed_in? && current_user.address
#      @events = Event.near([current_user.latitude, current_user.longitude], 25, order: 'distance') 
#    elsif request.location 
#      @events = Event.near([request.location.latitude, request.location.longitude], 25, order: 'distance') 
#    else  
#      @events = Event.near("Washington, DC", 100, order: 'distance')
      # Event where address = "online"
    else
      @events = Event.all
    end

#    @event_strips = Event.event_strips_for_month(@shown_month, :include => :some_relation, :conditions => 'some_relations.some_column = true')
    @event_strips = @events.event_strips_for_month(@shown_month) 
  end

  private

    def is_number?(obj)
      obj.to_s == obj.to_i.to_s
    end

end
