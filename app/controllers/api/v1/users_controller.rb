class Api::V1::UsersController < Api::V1::BaseApiController
    def update
        if current_user.nil?
            render :json=> {:success=>false}
        elsif current_user.name == params[:id]
            if current_user.update_attributes(user_params)
                render :json=> {:success=>true, :about=>current_user.about}
            else
                render :json=> {:success=>false}
            end
        else
            render :json=> {:success=>false}
        end
    end

    private
    def user_params
        params.permit(:permalink, :name, :email, :password, 
                                     :about, :author, :password_confirmation, :genre1, :genre2, :genre3, 
                                     :twitter, :title, :profilepic, :profilepicurl, :remember_me, 
                                     :facebook, :address, :latitude, :longitude, :youtube1, :youtube2, 
                                     :youtube3, :videodesc1, :videodesc2, :videodesc3, :updating_password, 
                                     :agreeid, :purchid, :bannerpic, :on_password_reset, :stripesignup )
    end
end