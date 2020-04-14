class Api::V1::UsersController < Api::V1::BaseApiController
    def update
        if current_user.nil?
            render :json=> {:success=>false}
            return
        end
        if current_user.name == params[:id]
            render :json=> {:success=>true}
        else
            render :json=>{:success=>false}
        end
    end
end