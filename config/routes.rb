Untitled::Application.routes.draw do
  resources :applications
  match "applications/:id/allow" => 'Applications#allow', as: 'allow'
  match "applications/:id/deny" => 'Applications#deny', as: 'deny'
  #match "applications/:id/default_deny" => 'Applications#default_deny', as: 'default_deny'
  #match "applications/:id/default_allow" => 'Applications#default_allow', as: 'default_allow'

  match "change_password" => 'ChangePassword#index', as: 'change_password'
  #match "applications" => 'User#applications', as: 'applications'

  get "user/" => 'user#index'

  get "user/edit"
  get "user/edit/:id" => 'user#edit', :constraints => { :id => /.*/ }
  post "user/edit/:id" => 'user#edit', :constraints => { :id => /.*/ }
  post "user/create" => 'user#create'
  get "user/create" => 'user#new'

  get "user/view"
  get "user/view/:id" => 'user#view', :constraints => { :id => /.*/ }

  get "user/delete/:id" => 'user#delete', :constraints => { :id => /.*/ }

  get "session/admin" => 'session#admin'
  get "session/user" => 'session#user'
  get "session/logout" => 'session#logout'

  get "user/new"
  post "user/new"

  root :to => 'user#index'

  #get "users/all" => 'users#all'
  #
  #get "users/find"
  #
  #get "tests/" => 'tests#index'

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
