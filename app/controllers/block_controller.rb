class BlockController < ApplicationController
    def block
        # get person to block and owner of convo
        to_block = User.find_by_id(params[:to_block])
        owner = User.find_by_id(params[:owner])

        # get blockedBy array and BlockedUsers array
        array = to_block.blockedBy
        array2 = owner.BlockedUsers

        # check if user has already been blocked
        if !array2.includes? to_block.permalink
            to_block.update({'blockedBy': array << owner.permalink})        # add owner of convo to blockedBy array
            owner.update({'BlockedUsers': array2 << to_block.permalink})    # add user to be blocked to owner's BlockedUsers array
        end
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

    def liveCount
        render :json => {:success => true, :html => (render_to_string partial: "layouts/live_count")}
    end
end
