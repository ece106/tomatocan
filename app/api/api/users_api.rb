require 'net/http'

module Api
  class UsersApi < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api

    helpers do

      def current_user
        @current_user ||= logged_in_user
      end

      def encode_token(payload)
        payload[:exp] = Time.now.to_i + 604800 # Token expires after a week.
        if Rails.env.production?
          JWT.encode(payload, ENV['JWT_SECRET'], 'HS256')
        else
          JWT.encode(payload, JWT_SECRET, 'HS256')
        end
      end

      def auth_header
        request.headers['Authorization']
      end

      def decoded_token
        if auth_header
          token = auth_header.split(' ')[1]
          begin
            if Rails.env.production?
              JWT.decode(token, ENV['JWT_SECRET'], true, { algorithm: 'HS256' })
            else
              JWT.decode(token, JWT_SECRET, true, { algorithm: 'HS256' })
            end
          rescue JWT::DecodeError
            nil
          end
        end
      end

      def logged_in_user
        if decoded_token && decoded_token[0]['exp'] > Time.now.to_i
          user_id = decoded_token[0]['user_id']
          @user = User.find_by(id: user_id)
        end
      end

      def logged_in?
        !!current_user
      end

      def remove_nil_from_collection!(object_collection)
        object_collection.as_json.each do |obj|
          obj.reject! { |key, value| value.nil? }
        end
      end

      def user_info
        { "name": @user.name, "permalink": @user.permalink, "profilepic": @user.profilepic.url, "about": @user.about,
          "genre1": @user.genre1, "genre2": @user.genre2, "genre3": @user.genre3, "bannerpic": @user.bannerpic.url }
      end
      def event_info(event)
        user = User.find_by(id: event.user_id)
        info = { "name": event.name, "start_at": event.start_at, "end_at": event.end_at, "topic": event.topic,
          "permalink": user.permalink, "username": user.name, "id": event.id, "chatroom": event.chatroom }
        if event.users
          info[:users] = event.users.pluck(:permalink)
        end
        info
      end
      def events_info(events)
        info = []
        events.each do |event|
          info << event_info(event)
        end
        info
      end
    end

    post '/login' do
      @user = User.find_by(email: params[:email])
      if @user && @user.authenticate(params[:email], params[:password])
        status 200
        { "token": encode_token({ user_id: @user.id }), "user": user_info}
      else
        status 401
      end
    end

    post '/register' do
      @user = User.new(params[:user])

      if @user.save
        status 201
        { "token": encode_token({ user_id: @user.id }), "user": user_info}
      else
        status 409
        { "errors": @user.errors }
      end
    end

    resource :oauth do
      post '/facebook' do
        if Rails.env.production?
          app_id = ENV['FACEBOOK_APP_ID']
          app_secret = ENV['FACEBOOK_APP_SECRET']
        else
          app_id = FACEBOOK_APP_ID
          app_secret = FACEBOOK_APP_SECRET
        end
        uri = URI.parse("https://graph.facebook.com/debug_token?input_token=#{params[:access_token]}&access_token=#{app_id}|#{app_secret}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
        
        res = JSON.parse(response.body)
        data = res["data"]
        if data["is_valid"] && data["app_id"] == app_id
          uri = URI.parse("https://graph.facebook.com/#{params["user_id"]}?fields=email&access_token=#{params[:access_token]}")
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          request = Net::HTTP::Get.new(uri.request_uri)
          response = http.request(request)
          res = JSON.parse(response.body)
          if res["email"]
            @user = User.find_by(email: res["email"])
            if @user
              status 200
              { "token": encode_token({ user_id: @user.id }), "user": user_info }
            else
              name = res["email"].split('@')[0]
              if name.length > 15
                name = name[0..14]
              end
              @user = User.new()
              @user.permalink = (name + rand.to_s[2..6])
              @user.permalink = @user.permalink.gsub(/[^0-9a-z]/i, '')
              @user.email = res["email"]
              @user.password = Devise.friendly_token[0, 20]
              @user.name = name
              if @user.save
                status 200
                { "token": encode_token({ user_id: @user.id }), "user": user_info }
              else
                status 400
                { "errors": @user.errors }
              end
            end
          else
            status 400
            { "errors": "email field is inaccessible." }
          end
        else
          status 400
        end
      end

      post '/google' do
        if Rails.env.production?
          app_id = ENV['GOOGLE_CLIENT_ID']
          app_secret = ENV['GOOGLE_CLIENT_SECRET']
        else
          app_id = GOOGLE_CLIENT_ID
          app_secret = GOOGLE_CLIENT_SECRET
        end
        uri = URI.parse("https://oauth2.googleapis.com/tokeninfo?id_token=#{params["id_token"]}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        req = Net::HTTP::Get.new(uri.request_uri)
        res = http.request(req)
        res = JSON.parse(res.body)
        puts(res)
        if res["aud"] == app_id && res["email"]
          @user = User.find_by(email: res["email"])
          if @user
            status 200
            { "token": encode_token({ user_id: @user.id }), "user": user_info }
          else
            name = res["email"].split('@')[0]
            if name.length > 15
              name = name[0..14]
            end
            @user = User.new()
            @user.permalink = name + rand.to_s[2..6]
            @user.email = res["email"]
            @user.password = Devise.friendly_token[0, 20]
            @user.name = name
            if @user.save
              status 200
              { "token": encode_token({ user_id: @user.id }), "user": user_info }
            else
              status 400
              { "errors": @user.errors }
            end
          end
        else
          status 400
        end
      end
    end

    resource :users do
      desc 'Return information about the authenticated user.'
      get '/' do
        if logged_in?
          response = user_info
          response['email'] = @user.email
          puts('user is logged in.')
          status 200
          response
        else
          status 401
        end
      end

      desc 'Get rsvps for authenticated user.'
      get '/rsvps' do
        if logged_in?
          rsvps = @user.rsvpqs
          events = []
          rsvps.each do |rsvp|
            events << Event.find_by(id: rsvp.event_id)
          end
          status 200
          events_info(events)
        else
          status 401
        end
      end

      route_param :target_permalink, type: String do
        desc 'Return information about the user with the given permalink.'
        get '/' do
          @user = User.find_by(permalink: params[:target_permalink])
          if @user
            user_info
          else
            status 404
          end
        end

        desc 'Update specified user.'
        params do
          optional :permalink, type: String
          optional :name, type: String
          optional :email, type: String
          optional :password, type: String
          optional :about, type: String
          optional :genre1, type: String
          optional :genre2, type: String
          optional :genre3, type: String
          optional :profilepic, type: File
          optional :bannerpic, type: File
        end
        put '/' do
          if logged_in? && current_user.permalink == params[:target_permalink]
            if current_user.update(declared(params, include_missing: false).except(:target_permalink))
              status 200
              user_info
            else
              status 409
              { "errors": current_user.errors.messages }
            end
          else
            status 401
          end
        end
      end
    end

    resource :events do
      desc 'Get all upcoming events.'
      get '/' do
        events_info(Event.where('end_at > ?', Time.now - 7.hours))
      end
      
      desc 'Create a new event.'
      params do
        requires :name, type: String
        requires :start_at, type: String
        optional :desc, type: String
        optional :topic, type: String
      end
      post '/' do
        if logged_in?
          @event = current_user.events.build(declared(params, include_missing: false))
          if @event.start_at
            @event.end_at = @event.start_at + 1.hours
          end
          @event.topic = "Conversation"
          @event.update(user_id: current_user.id)
          if @event.save
            status 201
            {}
          else
            status 409
            { 'errors': @event.errors }
          end
        else
          status 401
        end
      end


      route_param :target_event_id do
        desc 'Update existing event.'
        params do
          optional :name, type: String

          # Technically these are DateTimes, but the request should be allowed for any string.
          # The validators will catch invalid times when @event.update is called.
          optional :start_at, type: String
          optional :end_at, type: String

          optional :desc, type: String
          optional :topic, type: String
        end
        put '/' do
          if logged_in?
            @event = Event.find_by(id: params[:target_event_id])
            if @event
              if @event.user_id == current_user.id
                if @event.update(declared(params, include_missing: false).except(:target_event_id))
                  status 200
                  {}
                else
                  status 409
                  { 'errors': @event.errors.messages }
                end
              else
                status 401
              end
            else
              status 404
            end
          else
            status 401
          end
        end

        desc 'Delete the specified event.'
        delete '/' do
          if logged_in?
            @event = Event.find_by(id: params[:target_event_id])
            if @event
              if @event.user_id == current_user.id
                @event.destroy
                status 200
                {}
              else
                status 401
              end
            else
              status 404
            end
          else
            status 401
          end
        end

        desc 'Rsvp the authenticated user to the specified event'
        params do
          requires :action, type: String
        end
        post '/rsvp' do
          if logged_in?
            @event = Event.find_by(id: params[:target_event_id])
            if @event
              if params[:action] == 'add'
                @rsvp = current_user.rsvpqs.build({
                  "event": @event
                })
                if @rsvp.save
                  status 201
                  {}
                else
                  status 400
                  { "errors": @rsvp.errors }
                end
              elsif params[:action] == 'remove'
                @rsvp = current_user.rsvpqs.find_by(user: current_user)
                if @rsvp && @rsvp.destroy
                  status 201
                  {}
                else
                  status 400
                end
              else
                status 400
              end
            else
              status 404
            end
          else
            status 401
          end
        end
      end
    end
  end
end