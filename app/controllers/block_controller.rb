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

        # return 200 ok
        head :ok
    end

    def unload
        # gets the current user
        current_user = User.find_by_id(params[:currentUser])

        # remove the current event from user's last_viewed array
        array = current_user.last_viewed
        array = array - [params[:event].to_i]
        current_user.update({'last_viewed': array})
        if params[:event] == nil || params[:event] == ""
          attendance_log = Attendance.find_by(user_id: params[:currentUser], time_out: nil)
        else  
          attendance_log = Attendance.find_by(user_id: params[:currentUser], event_id: params[:event], time_out: nil)
        end

        attendance_log.time_out = Time.now - 7.hours
        attendance_log.save

        # return 200 ok
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
        # return live_count layout
        render :json => {:success => true, :html => (render_to_string partial: "layouts/live_count")}
    end
end

When Dr. Lisa Schaefer was a federal contractor, an FAA employee locked her in a conference room and masturbated. The next day, in spite of (or because of?) her advanced education and her attempts to develop “perfect airspace” solutions, she was fired. So rather than go back to another FAA contractor position, she used her talents to produce Budget Justified, a movie, web series, and video-short reenacting what she witnessed in FAA and contractor offices. 
Dr. Schaefer is now the founder of ThinQ.tv, a new video chat platform for activism. After producing Budget Justified, she taught herself web development and created the platform herself. She now uses it not only to promote Coding While Female, but to mentor women and minorities in tech....