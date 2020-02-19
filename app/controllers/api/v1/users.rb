module API
    module V1
        class Users < Grape::API
            include API::V1::Defaults

            resource :users do
                desc "Return all users"
                get "" do
                    if (params.length() == 0)
                        User.all
                    else
                        User.where(name: params[:name]).all
                    end
                end
            end
        end
    end
end