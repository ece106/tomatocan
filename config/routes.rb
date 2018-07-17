Rails.application.routes.draw do
  resources :movieroles
  resources :movies
  resources :agreements
  resources :relationships

  resources :users do
    member do
      get :following, :followers
    end
  end

#  authenticated :user do
#    root to: "users#show"
     root to: "static_pages#home"
#  end

#  root to: 'static_pages#home'
#  get "attachments/show"
  get "attachments/download" 

  match 'home', to: 'static_pages#home', via: 'get'
  match 'faq', to: 'static_pages#faq', via: 'get'
  match 'tellfriends', to: 'static_pages#tellfriends', via: 'get'
  match 'tos', to: 'static_pages#tos', via: 'get'
  match 'aboutus', to: 'static_pages#aboutus', via: 'get'
  match 'suggestedperks', to: 'static_pages#suggestedperks', via: 'get'
  match 'apprenticeships', to: 'static_pages#apprenticeships', via: 'get'
  match 'bootcamp', to: 'static_pages#bootcamp', via: 'get'

  match '/events/pastevents' => "events#pastevents", :as => :events_pastevents, via: 'get'
  match '/events/online' => "events#online", :as => :events_online, via: 'get'

  resources :merchandises
  resources :phases
  resources :rsvpqs
  resources :groups
  resources :purchases
  resources :plans
  resources :events
  resources :reviews

devise_for :users, :skip => [:sessions, :passwords], controllers: {registrations: "users/registrations", passwords: "users/passwords"}
  as :user do
    get 'login' => 'devise/sessions#new', :as => :new_user_session
    post 'login' => 'devise/sessions#create', :as => :user_session
    delete 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session
    get "signup", :to => 'devise/registrations#new', :as => :new_user_signup
    post "signup", :to => 'devise/registrations#create', :as => :user_signup
    get "password", :to => 'devise/passwords#new', :as => :new_user_password
    get "newpassword", :to => 'devise/passwords#edit', :as => :edit_user_password
#    patch "password", :to => 'devise/passwords#update', :as => :user_password
#    put "password", :to => 'devise/passwords#update' #, :as => :user_password
    match '/password' => 'devise/passwords#create', as: :user_password, via: [:post]
    match '/password' => 'devise/passwords#update', via: [:put, :patch]
  end

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
#      get 'profileinfo', 'readerprofileinfo', 'orgprofileinfo' What is this route for???
      get 'blog' => "users#blog", :as => :blog
    end
  end

  match '/books' => "books#index", :as => :allbooks, via: 'get'
  match '/actors' => "users#actors", :as => :actors, via: 'get'
  match '/filmmakers' => "users#filmmakers", :as => :filmmakers, via: 'get'
  match '/authors' => "users#authors", :as => :authors, via: 'get'

  match '/:permalink' => "users#show", :as => :user_profile, via: 'get'
  match '/:permalink/followers' => "users#followerspage", :as => :user_followerspage, via: 'get'
  match '/:permalink/following' => "users#followingpage", :as => :user_followingpage, via: 'get'
  match '/:permalink/blog' => "users#blog", :as => :user_blog, via: 'get'
  match '/:permalink/books' => "users#booklist", :as => :user_booklist, via: 'get'
  match '/:permalink/movies' => "users#movielist", :as => :user_movielist, via: 'get'
  match '/:permalink/movieedit' => "users#movieedit", :as => :user_movieedit, via: 'get'
  match '/:permalink/eventlist' => "users#eventlist", :as => :user_eventlist, via: 'get'
  match '/:permalink/pastevents' => "users#pastevents", :as => :user_pastevents, via: 'get'
  match '/:permalink/profileinfo' => "users#profileinfo", :as => :user_profileinfo, via: 'get'
  match '/:permalink/createstripeaccount' => "users#createstripeaccount", :as => :user_createstripeaccount, via: 'get'
  match '/:permalink/addbankaccount' => "users#addbankaccount", :as => :user_addbankaccount, via: 'get'
  match '/:permalink/manageaccounts' => "users#manageaccounts", :as => :user_manageaccounts, via: 'get'
  match '/:permalink/correcterrors' => "users#correcterrors", :as => :user_correcterrors, via: 'get'
  match '/:permalink/dashboard' => "users#dashboard", :as => :user_dashboard, via: 'get'
  match '/:permalink/readerprofileinfo' => "users#readerprofileinfo", :as => :user_readerprofileinfo, via: 'get'
  match '/:permalink/edit' => "users#edit", :as => :user_edit, via: 'get'
  match '/:permalink/stream' => "users#stream", :as => :user_stream, via: 'get'
  match '/:permalink/groups' => "users#groups", :as => :user_groups, via: 'get'
  match '/:permalink/phases' => "users#phases", :as => :user_phases, via: 'get'
  match '/:permalink/perks' => "users#perks", :as => :user_merchandise, via: 'get'
  match '/:permalink/about' => "users#about", :as => :user_about, via: 'get'
 
  match '/groups/:permalink/eventlist' => "groups#eventlist", :as => :group_eventlist, via: 'get'
  match '/groups/:permalink/news' => "groups#news", :as => :group_news, via: 'get'
  match '/groups/:permalink/createstripeaccount' => "groups#createstripeaccount", :as => :group_createstripeaccount, via: 'get'
  match '/groups/:permalink/addbankaccount' => "groups#addbankaccount", :as => :group_addbankaccount, via: 'get'
  match '/groups/:permalink/manageaccounts' => "groups#manageaccounts", :as => :group_manageaccounts, via: 'get'
  match '/groups/:permalink/correcterrors' => "groups#correcterrors", :as => :group_correcterrors, via: 'get'
  match '/groups/:permalink/dashboard' => "groups#dashboard", :as => :group_dashboard, via: 'get'

  post '/groups/:permalink/managesales' => 'groups#updatestripeacnt', :as => :group_updatestripeacnt
  post '/groups/:permalink/addbankaccount' => 'groups#addbankacnt', :as => :group_addbankacnt
  post '/groups/:permalink/createstripeacnt' => 'groups#createstripeacnt', :as => :group_createstripeacnt
  post '/groups/:permalink/correcterr' => 'groups#correcterr', :as => :group_correcterr

  match '/phases/:permalink/merchandise' => "phases#merchandise", :as => :phase_merchandise, via: 'get'
  match '/phases/:permalink/patronperk' => "phases#patronperk", :as => :phase_patronperk, via: 'get'
  match '/phases/:permalink/storytellerperks' => "phases#storytellerperks", :as => :phase_storytellerperks, via: 'get'
  match '/phases/:permalink/edit' => "phases#edit", :as => :phase_edit, via: 'get'
  match '/phases/:permalink' => "phases#show", :as => :phase_show, via: 'get'
  
  post '/:permalink/managesales' => 'users#updatestripeacnt', :as => :user_updatestripeacnt
  post '/:permalink/addbankaccount' => 'users#addbankacnt', :as => :user_addbankacnt
  post '/:permalink/createstripeacnt' => 'users#createstripeacnt', :as => :user_createstripeacnt
  post '/:permalink/correcterr' => 'users#correcterr', :as => :user_correcterr

  post '/:permalink/approveagreement' => 'users#approveagreement', :as => :approveagreement_user
  post '/:permalink/declineagreement' => 'users#declineagreement', :as => :declineagreement_user
  post '/:permalink/markfulfilled' => 'users#markfulfilled', :as => :markfulfilled_user

#  get '/:friendly_id', to: 'groups#show' 

  resources :books do
    resources :purchases
    member do
      get 'buy'
    end
  end
  resources :merchandises do
    resources :purchases
    member do
      get 'buy'
    end
  end
end