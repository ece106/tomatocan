module API
    module V1
        class Signup < Grape::API
            include API::V1::Defaults
            
            resource :signup do
                desc "create a new user"
                params do
                    requires :name, type: String
                    requires :password, type: String
                    requires :email, type: String
                end
                post "" do
                    @user = User.new(:name => params[:name], :permalink => params[:name], :email => params[:email], :password => params[:password], :password_confirmation => params[:password])
                    @user.save
                end
            end
        end
    end
end