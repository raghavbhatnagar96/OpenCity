Rails.application.routes.draw do
  #resources :resources
  root 'home#index'
  resources :worlds
  devise_for :users, controllers: {registrations: "users/registrations", sessions: "users/sessions"}
  get 'resources/upload_resource' => 'resources#new'
  post 'resources/upload_resource' => 'resources#create'
  post 'worlds/create_world' => 'worlds#create', :as =>:create_world
  get 'my_worlds' => 'worlds#my_worlds'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Some setup you must do manually if you haven't yet:

  # Ensure you have overridden routes for generated controllers in your routes.rb.
  # For example:

  #   Rails.application.routes.draw do
  #     devise_for :users, controllers: {
  #       sessions: 'users/sessions'
  #     }
  #   end
  #routes for roles
  get 'roles/' => 'worlds#add_remove_role', :as => :add_remove_role
  post 'addrole/' => 'worlds#add_role', :as => :add_role
  post 'removerole/' => 'worlds#remove_role', :as => :remove_role
  post 'privilege/' => 'worlds#change_privilege', :as => :change_privilege

  #route for adding world to role_table
  get 'changelocation/' => 'worlds#change_location_landing', :as => :change_location_landing
  post 'location/' => 'worlds#change_location', :as => :change_location
  get 'worldaddremove/' => 'worlds#add_remove_world', :as => :add_remove_world
  post 'worldadd/' => 'worlds#add_world', :as => :add_world
  post 'worldremove/' => 'worlds#remove_world', :as => :remove_world
  post 'worldchange/' => 'worlds#change_world_role', :as => :change_world_role
  
  #routes for logs
  get 'logs/' => 'home#view_logs', :as => :view_logs
  get 'logs/result/' => 'application#query', :as => :query
  
  #routes for world settings
  get 'world/settings/' => 'worlds#world_settings', :as => :world_settings
  get 'world/settings/admin/' => 'worlds#admin_world_settings', :as => :admin_world_settings
  
  #routes for UOD
  get 'home/createUOD' => 'application#createUOD'
  post 'create_UOD' => 'application#create_UOD', :as => :create_UOD
  
  #routes for resources
  get 'resources/user_resources' => 'resources#user_resources', :as => :user_Resources
  get 'resources/view_resource/:id' => 'resources#view_resource', :as => :view_Resource
end
