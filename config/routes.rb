Crowdpublishtv::Application.routes.draw do

#  authenticated :user do
#    root to: "users#show"
     root to: "static_pages#home"
#  end

#  root to: 'static_pages#home'
  get "attachments/show"
  get "attachments/download" 

  match 'home', to: 'static_pages#home', via: 'get'
  match 'howwork', to: 'static_pages#howwork', via: 'get'
  match 'localauthorsscene', to: 'static_pages#localauthorsscene', via: 'get'
  match 'tos', to: 'static_pages#tos', via: 'get'
  match 'apprenticeships', to: 'static_pages#apprenticeships', via: 'get'
  match 'getinvolved', to: 'static_pages#getinvolved', via: 'get'
  match 'internships', to: 'static_pages#apprenticeships', via: 'get'

  match '/events/pastevents' => "events#pastevents", :as => :events_pastevents, via: 'get'
  match '/events/online' => "events#online", :as => :events_online, via: 'get'
  match '/calendar/online' => "calendar#online", :as => :calendar_online, via: 'get'

  resources :rsvpqs
  resources :groups
  resources :purchases
  resources :plans
  resources :events
  resources :reviews

  devise_for :users, :skip => [:sessions], controllers: {registrations: "users/registrations"}
  as :user do
    get 'login' => 'devise/sessions#new', :as => :new_user_session
    post 'login' => 'devise/sessions#create', :as => :user_session
    delete 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session
    #get 'localauthors' => 'devise/registrations#localauthorsscene', :as => :localauthors
    get "signup", :to => 'devise/registrations#new', :as => :new_user_signup
    post "signup", :to => 'devise/registrations#create', :as => :user_signup
    #get 'users' => "users#index", :as => :users
  end

#  devise_for :users, controllers: {registrations: "users/registrations"}

  devise_scope :user do
    authenticated :user do
      root :to => 'static_pages#home', as: :authenticated_root
    end
    unauthenticated :user do
      root :to => 'static_pages#home', as: :unauthenticated_root
    end
  end


  match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}, via: 'get'

  match '/editbookreview',  to: 'reviews#editbookreview', via: 'get'
  match '/editauthorreview',  to: 'reviews#editauthorreview', via: 'get'
  #  match 'user_root_path', to: 'users/current_user'

  resources :users do
    resources :books
    member do
#      get 'profileinfo', 'readerprofileinfo', 'orgprofileinfo'
      get 'blog' => "users#blog", :as => :blog
    end
  end

  match '/books' => "books#index", :as => :allbooks, via: 'get'
  match '/:permalink' => "users#show", :as => :user_profile, via: 'get'
  match '/:permalink/blog' => "users#blog", :as => :user_blog, via: 'get'
  match '/:permalink/books' => "users#booklist", :as => :user_booklist, via: 'get'
  match '/:permalink/eventlist' => "users#eventlist", :as => :user_eventlist, via: 'get'
  match '/:permalink/pastevents' => "users#prevevents", :as => :user_pastevents, via: 'get'
  match '/:permalink/calendar' => "users#calendar", :as => :user_calendar, via: 'get'
  match '/:permalink/profileinfo' => "users#profileinfo", :as => :user_profileinfo, via: 'get'
  match '/:permalink/createstripeaccount' => "users#createstripeaccount", :as => :user_createstripeaccount, via: 'get'
  match '/:permalink/addbankaccount' => "users#addbankaccount", :as => :user_addbankaccount, via: 'get'
  match '/:permalink/managesales' => "users#managesales", :as => :user_managesales, via: 'get'
  match '/:permalink/readerprofileinfo' => "users#readerprofileinfo", :as => :user_readerprofileinfo, via: 'get'
  match '/:permalink/edit' => "users#edit", :as => :user_edit, via: 'get'
  match '/:permalink/stream' => "users#stream", :as => :user_stream, via: 'get'
  match '/:permalink/groups' => "users#groups", :as => :user_groups, via: 'get'
 
  match '/groups/:permalink/calendar' => "groups#calendar", :as => :group_calendar, via: 'get'
  match '/groups/:permalink/eventlist' => "groups#eventlist", :as => :group_eventlist, via: 'get'
  match '/groups/:permalink/news' => "groups#news", :as => :group_news, via: 'get'

  post '/:permalink/managesales' => 'users#updatestripeacnt', :as => :user_updatestripeacnt
  post '/:permalink/addbankaccount' => 'users#addbankacnt', :as => :user_addbankacnt
  post '/:permalink/createstripeacnt' => 'users#createstripeacnt', :as => :user_createstripeacnt
#  get '/:friendly_id', to: 'groups#show' 

  resources :books do
    resources :purchases
    member do
      get 'buy'
    end
  end
end
