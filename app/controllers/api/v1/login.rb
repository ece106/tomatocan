module API
    module V1
        class Login < Grape::API
            #prepend_before_filter :require_no_authentication, :only => [:create]
            include API::V1::Defaults
            #include Devise::Controllers::Helpers

            resource :login do
                params do
                    requires :password, type: String
                    requires :email, type: String
                end
             #   resource = User.where(email: params[:email]).all
             #   if resource.nil?
             #       render :json=> {:success=>false, :message=>"Error with your login or password"}, status=>401
             #   end
#
 #               if resource.valid_password?(params[:password])
  #                  sign_in("user", resource)
   #                 render :json=> {:success=>true, :auth_token=>resource.authentication_token}
    #            else
     #               render :json=> {:success=>false, :message=>"Error with your login or password.", :status=>401}
      #          end
            end
        end
    end
end