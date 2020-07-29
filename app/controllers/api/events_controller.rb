class Api::V1::EventsController < Api::V1::BaseApiController

    def index
        pdtnow = Time.now - 7.hours
        @events = Event.where( "end_at > ?", pdtnow)

        render json: @events
    end

    def create
        if current_user.nil?
            render :json=> {:success=>false}, :status=>401
            return
        end
        @event = current_user.events.build(event_params)
        @event.update_attribute(:user_id, current_user.id)
        if @event.save
            render :json=> {:success=>true, :token=>current_user.authentication_token}
        else
            render json: @event.errors, status: :unprocessable_entity
        end
    end

    def destroy
        if current_user.nil?
            render :json=> {:success=>false}, :status=>401
            return
        elsif Event.find_by_id(params[:id]).nil? or Event.find_by_id(params[:id]).user_id != current_user.id
            render :json=> {:success=>false}, :status=>422
            return
        end
        Event.find_by_id(params[:id]).destroy
        render :json=> {:success=>true}
    end

    def update
        @event = Event.find(params[:id])
        if @event.nil?
            render :json=> {:success=>false}, status=>422
            return
        elsif current_user.nil? or current_user.id != @event.user_id
            render :json=> {:success=>false}, :status=>401
            return
        end

        if @event.update_attributes(event_params)
            render :json=> {:success=>true, :name=>@event.name, :start_at=>@event.start_at, :end_at=>@event.end_at, :desc=>@event.desc}
        else
            render :json=> {:errors=>@event.errors}, :status=>422
        end
      end

    def event_params
        params.require(:event).permit(:address, :name, :start_at, :end_at, :desc, :latitude, :longitude, :user_id, :group1id, :group2id, :group3id )
    end
end