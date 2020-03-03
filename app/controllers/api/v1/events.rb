module API
    module V1
        class Events < Grape::API
            include API::V1::Defaults

            resource :events do
                desc "Return all events"
                get "" do
                    if (params.length() == 0)
                        Event.all
                    else
                        Event.where(name: params[:name]).all
                    end
                end
            end
        end
    end
end