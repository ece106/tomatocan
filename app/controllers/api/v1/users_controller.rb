class Api::V1::UsersController < Api::V1::BaseApiController
    def update
        if current_user.nil?
            render :json=> {:success=>false}, :status=>401
            return
        elsif current_user.name == params[:id]
            if current_user.valid_password?(params[:current_password]) and current_user.update_attributes(user_params)
                render :json=> {:success=>true, :privileged=>true, :name=>current_user.name, :token=>current_user.authentication_token, :profpic=>current_user.profilepic,
              :about=>current_user.about, :genre1=>current_user.genre1, :genre2=>current_user.genre2, :genre3=>current_user.genre3, :bannerpic=>current_user.bannerpic,
            :email=>current_user.email, :permalink=>current_user.permalink}
                return
            elsif current_user.update_attributes(user_params_less_access)
              render :json=> {:success=>true, :privileged=>false, :name=>current_user.name, :token=>current_user.authentication_token, :profpic=>current_user.profilepic,
              :about=>current_user.about, :genre1=>current_user.genre1, :genre2=>current_user.genre2, :genre3=>current_user.genre3, :bannerpic=>current_user.bannerpic,
            :email=>current_user.email, :permalink=>current_user.permalink}
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
                                     :twitter, :title, :profilepic, :remember_me,
                                     :facebook, :youtube1, :youtube2,
                                     :youtube3, :updating_password,
                                     :agreeid, :purchid, :bannerpic, :on_password_reset, :stripesignup )
    end
    def user_params_less_access
      params.permit(:name,
                                     :about, :author, :genre1, :genre2, :genre3,
                                     :twitter, :title, :profilepic, :remember_me,
                                     :facebook, :youtube1, :youtube2,
                                     :youtube3, :updating_password,
                                     :agreeid, :purchid, :bannerpic, :on_password_reset, :stripesignup )
    end
    def get_errors
        return current_user.errors.messages
      end
end
