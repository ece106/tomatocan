Crowdpublishtv::Application.routes.draw do

  resources :purchases

  resources :plans
  resources :purchases
  resources :events
  resources :reviews
#  resources 'users/:permalink', :to => 'User#show'

  match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}

  match '/profileinfo',  to: 'users#profileinfo'
  match '/readerprofileinfo',  to: 'users#readerprofileinfo'
  match '/orgprofileinfo',  to: 'users#orgprofileinfo'
  match '/editbookreview',  to: 'reviews#editbookreview'
  match '/editauthorreview',  to: 'reviews#editauthorreview'
  match '/infoerror',  to: 'users#inputerror'
  match '/me', to: 'users#booklist'
  match 'bookpdf_path', to: 'purchases/new'
  #  match 'user_root_path', to: 'users/current_user'

  get "attachments/show"
  get "attachments/download" 

  resources :users do
    resources :books
  end

  resources :books do
    resources :purchases
    member do
      get 'buy'
    end
  end

  devise_for :users, :skip => [:sessions]
  as :user do
    get 'login' => 'devise/sessions#new', :as => :new_user_session
    post 'login' => 'devise/sessions#create', :as => :user_session
    delete 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session
    get "signup", :to => 'devise/registrations#new', :as => :new_user_registration
    post "signup", :to => 'devise/registrations#create', :as => :user_registration
    #get '/:user' => "users#show", :as => :user
  end
  authenticated :user do
    root :to => "users#show"
  end
  resources :users do
    member do
      get 'booklist', 'blog', 'profileinfo', 'readerprofileinfo', 'orgprofileinfo'
    end
  end

  match '/:id' => "users#show", :as => :user_profile
  
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
