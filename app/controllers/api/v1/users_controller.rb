class Api::V1::UsersController < Api::V1::BaseApiController
    def update
        if current_user.nil?
            render :json=> {:success=>false}, :status=>401
            return
        elsif current_user.name == params[:id]
            if current_user.update_attributes(user_params)
                render :json=> {:success=>true, :token=>current_user.authentication_token}
                return
            else
                render :json=> {:success=>false, :errors=>get_errors}, :status=>422
                return
            end
        else
            render :json=> {:success=>false}, :status=>401
            return
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
    def get_errors
        errors = []
        if current_user.errors.messages[:name].present?
            errors.push(current_user.errors.messages[:name][0])
        end
=begin
        if current_user.errors.messages[:email].present?
          msg += ("Email " + @user.errors.messages[:email][0] + "\n")
        end
        if current_user.errors.messages[:permalink].present?
          msg += ("URL handle " + @user.errors.messages[:permalink][0] + "\n")
        end
        if current_user.errors.messages[:password_confirmation].present?
          msg += ( "Passwords do not match \n")
        end
        if current_user.errors.messages[:password].present?
          msg += ("Password " + @user.errors.messages[:password][0] + "\n")
        end
        if current_user.errors.messages[:twitter].present?
          msg += ("Twitter handle " + @user.errors.messages[:twitter][0] + "\n")
        end
=end
        return errors
      end
end