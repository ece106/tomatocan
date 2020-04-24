class Api::V1::EventsController < Api::V1::BaseApiController

    def index
        pdtnow = Time.now - 7.hours
        @events = Event.where( "end_at > ?", pdtnow)

        render json: @events
    end

    def create
        @event = current_user.events.build(event_params)
        @event.update_attribute(:user_id, params["event"]["usrid"])
        user = User.find(@event.usrid)
        @reminder_date = @event.start_at - 2.days
        respond_to do |format|
            if @event.save
                EventMailer.with(user: user , event: @event).event_reminder.deliver_later(wait_until: @reminder_date)
                render json: @event, status: :created, location: @event
            else
                render json: @event.errors, status: :unprocessable_entity
            end
        end
    end


    def event_params
        params.require(:event).permit(:address, :name, :start_at, :end_at, :desc, :latitude, :longitude, :usrid, :user_id, :group1id, :group2id, :group3id )
    end
end