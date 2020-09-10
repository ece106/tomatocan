class BlockController < ApplicationController
    def block
        # get person to block and owner of convo
        to_block = User.find_by_id(params[:to_block])
        owner = User.find_by_id(params[:owner])

        # get blockedBy array and BlockedUsers array
        array = to_block.blockedBy
        array2 = owner.BlockedUsers

        # check if user has already been blocked
        unless array2.include? (to_block.permalink)
            to_block.update({'blockedBy': array << owner.permalink})        # add owner of convo to blockedBy array
            owner.update({'BlockedUsers': array2 << to_block.permalink})    # add user to be blocked to owner's BlockedUsers array
        end

        # return 200 ok
        head :ok
    end

    def unblock
        # get to_unblock user and current_user
        to_unblock = User.find_by_id(params[:to_unblock_id])

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

        # return 200 ok
        head :ok
    end

    def unload
        # remove the current event from user's last_viewed array
        attendance_log = Attendance.find(params[:attendid])
        attendance_log.time_out = Time.now - 7.hours
        attendance_log.save

        # return 200 ok Why do we do this?
        head :ok
    end

    def is_blocked
        render plain: current_user.blockedBy, content_type: 'text/plain'
    end

    def signed_in?
        # if user signed in return true else return false
        if user_signed_in?
            render :json => {:success => true}
        else
            render :json => {:success => false}
        end
    end

    def loadAttendees
        # return attendees layout
        render :json => {:success => true, :html => (render_to_string partial: "layouts/attendees")}
    end

    def liveCount
        # return live_count layout Why the hell is this in blockcontroller
        render :json => {:success => true, :html => (render_to_string partial: "layouts/live_count")}
    end

end