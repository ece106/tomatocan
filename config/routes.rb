Rails.application.routes.draw do
  resources :relationships

  resources :users do
    member do
      get :following, :followers
    end
  end

  # authenticated :user do
  # root to: "users#show"
  root to: "static_pages#home"
  # end

  # get "attachments/show"
  get "attachments/download"
  get "settings/payment-info/users/auth/stripe_connect/callback", to: "users#stripe_callback"

  match 'home',           to: 'static_pages#home', via: 'get'
  match 'faq',            to: 'static_pages#faq', via: 'get'
  match 'getinvolved',    to: 'static_pages#getinvolved', via: 'get'
  match 'parents',        to: 'static_pages#parents', via: 'get'
  match 'boardofdirectors',        to: 'static_pages#boardofdirectors', via: 'get'
  match 'tos',            to: 'static_pages#tos', via: 'get'
  match 'aboutus',        to: 'static_pages#aboutus', via: 'get'
  match 'suggestedperks', to: 'static_pages#suggestedperks', via: 'get'
  match 'livestream',     to: 'static_pages#livestream', via: 'get'
  match 'ux',             to: 'static_pages#ux', via: 'get'
  match 'vieweronhost',   to: 'static_pages#vieweronhost', via: 'get'
  match 'jointheteam',    to: 'static_pages#jointheteam', via: 'get'
  match 'bystanderguidelines',    to: 'static_pages#bystanderguidelines', via: 'get'
  match 'drschaeferspeaking',     to: 'static_pages#drschaeferspeaking', via: 'get'
  match 'harassment',     to: 'static_pages#harassment', via: 'get'
  match 'fellowship',     to: 'static_pages#fellowship', via: 'get'
  match 'seniorliving',   to: 'static_pages#seniorliving', via: 'get'
  
  match '/merchandises/standardperks' => 'merchandises#standardperks', :as => :standardperks, via: 'get'
  match '/merchandises/new' => 'merchandises#new', :as => :createperk, via: 'get'

  resources :merchandises
  resources :rsvpqs
  resources :purchases
  resources :events
  resources :messages

  devise_for :users, :skip => [:sessions, :passwords], :controllers => {registrations: "users/registrations", passwords: "users/passwords", :omniauth_callbacks => "users/omniauth_callbacks"} 
  as :user do
    get 'login'  => 'devise/sessions#new',    :as => :new_user_session
    post 'login' => 'devise/sessions#create', :as => :user_session

    delete 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session
    get "signup", :to => 'devise/registrations#new', :as => :new_user_signup
    post "signup", :to => 'devise/registrations#create', :as => :user_signup
    get "password", :to => 'devise/passwords#new', :as => :new_user_password
    get "newpassword", :to => 'devise/passwords#edit', :as => :edit_user_password
    match '/password' => 'devise/passwords#create', as: :user_password, via: [:post]
    match '/password' => 'devise/passwords#update', via: [:put, :patch]
    # patch "password", :to => 'devise/passwords#update', :as => :user_password
    # put "password", :to => 'devise/passwords#update' #, :as => :user_password
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

  match '/:permalink'                => "users#show",           :as => :user_profile, via: 'get'
  match '/:permalink/followers'      => "users#followerspage",  :as => :user_followerspage, via: 'get'
  match '/:permalink/following'      => "users#followingpage",  :as => :user_followingpage, via: 'get'
  match '/:permalink/eventlist'      => "users#eventlist",      :as => :user_eventlist, via: 'get'
  match '/:permalink/pastevents'     => "users#pastevents",     :as => :user_pastevents, via: 'get'
  match '/:permalink/profileinfo'    => "users#profileinfo",    :as => :user_profileinfo, via: 'get'
  match '/:permalink/changepassword' => "users#changepassword", :as => :user_changepassword, via: 'get'
  match '/:permalink/controlpanel'   => "users#controlpanel",   :as => :user_controlpanel, via: 'get'
  match '/:permalink/dashboard'      => "users#dashboard",      :as => :user_dashboard, via: 'get'

  post '/:permalink/markfulfilled' => 'users#markfulfilled', :as => :markfulfilled_user

  # get '/:friendly_id', to: 'groups#show'

  resources :merchandises do
    resources :purchases
    member do
      get 'buy'
    end
  end

  namespace :api do
    namespace :v1 do
      devise_for :users
      resources :users
      resources :sessions
      resources :events
    end
  end

end