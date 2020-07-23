class BlockController < ApplicationController
    def block
        # get owner of convo and person to block
        to_block = User.find_by_id(params[:to_block])
        owner = User.find_by_id(params[:owner])

        # get blockedBy array
        array = to_block.blockedBy

        # add owner of convo to blockedBy array
        to_block.update({'blockedBy': array << owner.permalink})
        
        # update owner blockedUsers array
        array2 = owner.BlockedUsers
        owner.update({'BlockedUsers': array2 << to_block.permalink})
    end
    
    def unblock
        # get to_unblock user and current_user
        to_unblock = User.find_by_id(params[:to_unblock_id])
        current_user = User.find_by_id(params[:current_user_id])

        # get blocked by array
        array = to_unblock.blockedBy

        # remove current_user from blockedBy array
        array = array - [current_user.permalink]
        to_unblock.update({'blockedBy': array})
        
        # get blockedUsers array
        array = current_user.BlockedUsers

        # remove to_unblock from blockedUsers array
        array = array - [to_unblock.permalink]
        current_user.update({'BlockedUsers': array})
    end

    def unload
        current_user.update({'last_viewed': 0})
    end

    def is_blocked
        render plain: current_user.blockedBy, content_type: 'text/plain'
    end

    def signed_in?
        if user_signed_in?
            render plain: "true", content_type: 'text/plain'
        else
            render plain: "false", content_type: 'text/plain'
        end
        
    end

    def loadAttendees
        render :json => {:success => true, :html => (render_to_string partial: "layouts/attendees")}
    end

    def liveCount
        render :json => {:success => true, :html => (render_to_string partial: "layouts/live_count")}
    end
end
