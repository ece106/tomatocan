class StatsController < ApplicationController
    def upload_stats
        current_user = User.find_by_id(params[:user])
        current_user.update({'stats': current_user.stats << params[:stats]})
    end

    def get_stats

    end
end



