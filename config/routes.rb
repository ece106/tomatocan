Crowdpublishtv::Application.routes.draw do
  resources :reviews

  devise_for :users

  resources :books
  resources :users
  resources :plans
  resources :purchases
  resources :events

  match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}

#  resources :sessions, only: [:create, :destroy, :new]

  match '/profileinfo',  to: 'users#profileinfo'
  match '/infoerror',  to: 'users#inputerror'
  match '/me', to: 'users#booklist'
#  match '/bookadded',  to: 'books#anothernew'
#  match '/signup',  to: 'users#new'
#  match '/signin',  to: 'sessions#new'
#  match '/signout', to: 'sessions#destroy', via: :delete
#  match '/sessions/user',  to: 'users#show'
#  match 'user_root_path', to: 'users/current_user'

  devise_for :users
  authenticated :user do
    root :to => "users#booklist"
  end

#  devise_for :users
#  root :to => "devise/sessions#new"

  get "attachments/show"

  resources :users do
    resources :books
  end

  resources :books do
    resources :purchases
  end

  resources :books do
    member do
      get 'buy'
    end
  end

  devise_for :users
  resources :users do
    member do
      get 'booklist', 'blog', 'profileinfo'
    end
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
