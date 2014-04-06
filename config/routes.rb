Crowdpublishtv::Application.routes.draw do

  resources :purchases

  resources :plans
  resources :purchases
  resources :events
  resources :reviews
#  resources 'users/:permalink', :to => 'User#show'

  match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}, via: 'get'

  match '/profileinfo' => 'users#profileinfo', :as => 'profileinfo', via: 'get'
  match '/readerprofileinfo',  to: 'users#readerprofileinfo', via: 'get'
  match '/orgprofileinfo',  to: 'users#orgprofileinfo', via: 'get'
  match '/editbookreview',  to: 'reviews#editbookreview', via: 'get'
  match '/editauthorreview',  to: 'reviews#editauthorreview', via: 'get'
  match '/me', to: 'users#booklist', via: 'get'
  #  match 'user_root_path', to: 'users/current_user'

  get "attachments/show"
  get "attachments/download" 

  resources :users do
    resources :books
    member do
      get 'booklist', 'profileinfo', 'readerprofileinfo', 'orgprofileinfo'
      get 'blog' => "users#blog", :as => :blog
    end
  end

  match '/:permalink' => "users#show", :as => :user_profile, via: 'get'
  
  resources :books do
    resources :purchases
    member do
      get 'buy'
    end
  end

  authenticated :user do
    root to: "users#show"
  end

  devise_for :users, :skip => [:sessions]
  as :user do
    get 'login' => 'devise/sessions#new', :as => :new_user_session
    post 'login' => 'devise/sessions#create', :as => :user_session
    delete 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session
    get "signup", :to => 'devise/registrations#new', :as => :new_user_signup
    post "signup", :to => 'devise/registrations#create', :as => :user_signup
    #get '/:user' => "users#show", :as => :user
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
