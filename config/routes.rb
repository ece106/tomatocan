Rails.application.routes.draw do
  resources :timeslots
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

#  get "attachments/show"
  get "attachments/download" 

  get "settings/payment-info/users/auth/stripe_connect/callback", to:"users#stripe_callback"

  match 'home', to: 'static_pages#home', via: 'get'
  match 'faq', to: 'static_pages#faq', via: 'get'
  match 'tellfriends', to: 'static_pages#tellfriends', via: 'get'
  match 'faith', to: 'static_pages#faith', via: 'get'
  match 'tech', to: 'static_pages#tech', via: 'get'
  match 'international', to: 'static_pages#international', via: 'get'
  match 'tos', to: 'static_pages#tos', via: 'get'
  match 'aboutus', to: 'static_pages#aboutus', via: 'get'
  match 'suggestedperks', to: 'static_pages#suggestedperks', via: 'get'
  match 'livestream', to: 'static_pages#livestream', via: 'get'
  match '/merchandises/standardperks' => 'merchandises#standardperks', :as => :standardperks, via: 'get'
  match '/merchandises/new' => 'merchandises#new', :as => :createperk, via: 'get'
    
  resources :merchandises
  resources :rsvpqs
  resources :purchases
  resources :events

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

  match '/youtubers' => "users#youtubers", :as => :youtubers, via: 'get'
  match '/supportourwork' => "users#supportourwork", :as => :supportourwork, via: 'get'

  match '/:permalink' => "users#show", :as => :user_profile, via: 'get'
  match '/:permalink/followers' => "users#followerspage", :as => :user_followerspage, via: 'get'
  match '/:permalink/following' => "users#followingpage", :as => :user_followingpage, via: 'get'
  match '/:permalink/eventlist' => "users#eventlist", :as => :user_eventlist, via: 'get'
  match '/:permalink/pastevents' => "users#pastevents", :as => :user_pastevents, via: 'get'
  match '/:permalink/profileinfo' => "users#profileinfo", :as => :user_profileinfo, via: 'get'
  match '/:permalink/changepassword' => "users#changepassword", :as => :user_changepassword, via: 'get'
  match '/:permalink/controlpanel' => "users#controlpanel", :as => :user_controlpanel, via: 'get'
  match '/:permalink/dashboard' => "users#dashboard", :as => :user_dashboard, via: 'get'

  match '/:permalink/timeslots' => "users#timeslots", :as => :user_timeslots, via: 'get'
 
  post '/:permalink/markfulfilled' => 'users#markfulfilled', :as => :markfulfilled_user

#  get '/:friendly_id', to: 'groups#show' 

  resources :merchandises do
    resources :purchases
    member do
      get 'buy'
    end
  end
end
