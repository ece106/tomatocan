class BlockController < ApplicationController
    def block
        array = User.find_by_id(params[:to_block]).blockedBy
        User.find_by_id(params[:to_block]).update({'blockedBy': array << @user.permalink})
    
        array2 = User.find_by_id(params[:owner]).BlockedUsers
        User.find_by_id(params[:owner]).update({'BlockedUsers': array2 << User.find_by_id(params[:to_block]).permalink})
    end
    
    def unblock
        array = User.find_by_permalink(params[:to_unblock]).blockedBy
        array = array - [current_user.permalink]
        User.find_by_permalink(params[:to_unblock]).update({'blockedBy': array})
        
        array2 = current_user.BlockedUsers
        array2 = array2 - [User.find_by_permalink(params[:to_unblock]).permalink]
        current_user.update({'BlockedUsers': array2})
    end

    def unload
        current_user.update({'last_viewed': 0})
    end

    def is_blocked
        render json: {blocked_by: current_user.blockedBy}
    end

    def signed_in?
        if user_signed_in?
            render json: {signed_in: 'true'}
        else
            render json: {signed_in: 'false'}
        end
    end
end
