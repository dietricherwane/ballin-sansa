HubsOffice::Application.routes.draw do
	#root :to => "users#dashboard"
  root :to => redirect("/users/sign_in")
  #devise_scope :user do
		#root to: "devise/sessions#new"
	#end
  
  resources :statuses
  
  
  devise_for :users, :controllers => {:registrations => "devise/registrations", :sessions => "devise/sessions", :passwords => "devise/passwords"}
  
  devise_scope :user do
  	get 'dashboard' => 'devise/registrations#new', :as => :administrator_dashboard
  	get "user/edit_profile/:id" => "devise/registrations#edit", :as => :edit_user_profile
  	patch 'user/update_profile' => 'devise/registrations#update_profile', :as => :update_user_profile
  end
  #get 'user/edit_profile/:id' => 'users#edit_profile', :as => :edit_user_profile
  #get "user/edit_profile/:id" => "devise/registrations#edit", :as => :edit_user_profile
  #put 'user/update_profile' => 'users#update_profile', :as => :update_user_profile
  #get 'dashboard' => 'profiles#index', :as => :administrator_dashboard
  
  get 'user/search' => 'users#search', :as => :search_user
  get 'user/enable_profile/:id' => 'users#enable_profile', :as => :enable_user_profile
  get 'user/disable_profile/:id' => 'users#disable_profile', :as => :disable_user_profile 
  
  get "services" => "services#index", :as => :services
  post "service/create" => "services#create", :as => :create_service
  get "service/create" => "services#index"
  get "service/edit/:id" => "services#edit", :as => :edit_service
  get "service/enable" => "services#enable_service", :as => :enable_service
  get "service/disable" => "services#disable_service", :as => :disable_service
  post "service/update" => "services#update", :as => :update_service
  get "service/update" => "services#index"
  
  get "operations" => "operation_types#index", :as => :operation_types
  post "operation/create" => "operation_types#create", :as => :create_operation_type
  get "operation/create" => "operation_types#index"
  get "operation/edit/:id" => "operation_types#edit", :as => :edit_operation_type
  get "operation/enable" => "operation_types#enable", :as => :enable_operation_type
  get "operation/disable" => "operation_types#disable", :as => :disable_operation_type
  post "operation/update" => "operation_types#update", :as => :update_operation_type
  get "operation/update" => "operation_types#index"
  get "operation/get_operations_from_service" => "operation_types#get_operations_from_service"
  
  
  get "inheritors" => "inheritors#index", :as => :inheritors
  post "inheritor/create" => "inheritors#create", :as => :create_inheritor
  get "inheritor/create" => "inheritors#index"
  get "inheritor/edit/:id" => "inheritors#edit", :as => :edit_inheritor
  get "inheritor/link_to_operation/:id" => "inheritors#link_to_operation", :as => :link_inheritor_to_operations
  post "inheritor/create_link_to_operation" => "inheritors#create_link_to_operation"
  get "inheritor/create_link_to_operation" => "inheritors#index"
  get "inheritor/edit/:id" => "inheritors#edit"
  post  "inheritor/update" => "inheritors#update"
  get  "inheritor/update" => "inheritors#index"
  
  get "inheritor_types" => "inheritor_types#index", :as => "inheritor_types"
  post "inheritor_type/create" => "inheritor_types#create"
  get "inheritor_type/create" => "inheritor_types#index"
  
  get "bank_types" => "bank_types#index", :as => :bank_types
  post "bank_type/create" => "bank_types#create"
  get "bank_type/create" => "bank_types#index"
  
  get "banks" => "banks#index", :as => :banks
  post "bank/create" => "banks#create"
  get "bank/create" => "banks#index"
  get "bank/edit/:id" => "banks#edit"
  post "bank/update" => "banks#update"
  get "bank/update" => "banks#index"
  get "bank/enable/:id" => "banks#enable_bank", as: :enable_bank
  get "bank/disable/:id" => "banks#disable_bank", as: :disable_bank
  
  get "wallet_fees" => "payment_way_fees#index", :as => :payment_way_fees
  
  get "wallets" => "payment_way_fees#index", :as => :wallets
  post "wallet/create" => "payment_way_fees#create", :as => :create_wallets
  get "wallet/create" => "payment_way_fees#index"
  get "wallet/edit/:id" => "payment_way_fees#edit"
  post "wallet/update" => "payment_way_fees#update"
  get "wallet/update" => "payment_way_fees#index"
  
  get "transactions" => "transactions#index", :as => :transactions
  get "transactions/per_service/:id" => "transactions#list_per_service", :as => :transactions_per_service
  
  get "profile/custom" => "profiles#custom_profiles", as: :custom_profiles_dashboard
  get "profiles" => "profiles#index", as: :profiles
  post "profile/create" => "profiles#create"
  get "profile/create" => "profiles#index"
  get "profile/edit/:id" => "profiles#edit", as: :edit_profile
  post "profile/update" => "profiles#update"
  get "profile/update" => "profiles#index"
  get "profiles/edit_rights" => "profiles#edit_rights", as: :edit_profiles_rights
  get "profile/right/enable_create_user/:id" => "profiles#enable_create_user_right", as: :enable_create_user_right
  get "profile/right/disable_create_user/:id" => "profiles#disable_create_user_right", as: :disable_create_user_right
  get "profile/right/enable_edit_user_data/:id" => "profiles#enable_edit_user_data_right", as: :enable_edit_user_data_right
  get "profile/right/disable_edit_user_data/:id" => "profiles#disable_edit_user_data_right", as: :disable_edit_user_data_right
  
  get "profile/right/enable_create_service/:id" => "profiles#enable_create_service_right", as: :enable_create_service_right
  get "profile/right/disable_create_service/:id" => "profiles#disable_create_service_right", as: :disable_create_service_right
  
  get "profile/right/enable_edit_service/:id" => "profiles#enable_edit_service_right", as: :enable_edit_service_right
  get "profile/right/disable_edit_service/:id" => "profiles#disable_edit_service_right", as: :disable_edit_service_right
  
  get "profile/right/enable_create_operation/:id" => "profiles#enable_create_operation_right", as: :enable_create_operation_right
  get "profile/right/disable_create_operation/:id" => "profiles#disable_create_operation_right", as: :disable_create_operation_right
  
  get "profile/right/enable_edit_operation/:id" => "profiles#enable_edit_operation_right", as: :enable_edit_operation_right
  get "profile/right/disable_edit_operation/:id" => "profiles#disable_edit_operation_right", as: :disable_edit_operation_right
  
  get "profile/right/enable_create_inheritor/:id" => "profiles#enable_create_inheritor_right", as: :enable_create_inheritor_right
  get "profile/right/disable_create_inheritor/:id" => "profiles#disable_create_inheritor_right", as: :disable_create_inheritor_right
  
  get "profile/right/enable_edit_inheritor/:id" => "profiles#enable_edit_inheritor_right", as: :enable_edit_inheritor_right
  get "profile/right/disable_edit_inheritor/:id" => "profiles#disable_edit_inheritor_right", as: :disable_edit_inheritor_right
  
  get "profile/right/enable_create_bank/:id" => "profiles#enable_create_bank_right", as: :enable_create_bank_right
  get "profile/right/disable_create_bank/:id" => "profiles#disable_create_bank_right", as: :disable_create_bank_right
  
  get "profile/right/enable_edit_bank/:id" => "profiles#enable_edit_bank_right", as: :enable_edit_bank_right
  get "profile/right/disable_edit_bank/:id" => "profiles#disable_edit_bank_right", as: :disable_edit_bank_right
  
  get "profile/right/enable_create_wallet/:id" => "profiles#enable_create_wallet_right", as: :enable_create_wallet_right
  get "profile/right/disable_create_wallet/:id" => "profiles#disable_create_wallet_right", as: :disable_create_wallet_right
  
  get "profile/right/enable_edit_wallet/:id" => "profiles#enable_edit_wallet_right", as: :enable_edit_wallet_right
  get "profile/right/disable_edit_wallet/:id" => "profiles#disable_edit_wallet_right", as: :disable_edit_wallet_right
  
  get "profile/right/enable_view_transactions/:id" => "profiles#enable_view_transactions_right", as: :enable_view_transactions_right
  get "profile/right/disable_view_transactions/:id" => "profiles#disable_view_transactions_right", as: :disable_view_transactions_right
  
  get "profile/right/enable_create_profile/:id" => "profiles#enable_create_profile_right", as: :enable_create_profile_right
  get "profile/right/disable_create_profile/:id" => "profiles#disable_create_profile_right", as: :disable_create_profile_right
  
  get "profile/right/enable_edit_profile/:id" => "profiles#enable_edit_profile_right", as: :enable_edit_profile_right
  get "profile/right/disable_edit_profile/:id" => "profiles#disable_edit_profile_right", as: :disable_edit_profile_right
  
  #devise_scope :user do
  	#match '/users/sign_out' => 'devise/sessions#destroy'
  	#match 'create_user' => 'devise/registrations#new', :as => :dashboard_administrator
  	#match "users/search_ajax" => "devise/users#search_ajax"
  	#match "users/get_directions" => "devise/users#get_directions"
  	#match "users/get_workshops" => "devise/users#get_workshops"
  	#match "user/edit" => "devise/registrations#edit", :as => :edit_user
  	#match "users/enable" => "devise/users#enable", :as => :enable_user
  	#match "users/disable" => "devise/users#disable", :as => :disable_user
  	#match "users/delete" => "devise/users#delete", :as => :delete_user
  	#match 'user/update' => 'devise/users#update', :as => :update_user
  #end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
