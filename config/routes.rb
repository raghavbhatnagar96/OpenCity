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
  get 'world/settings/' => 'worlds#world_settings', :as => :world_settings
  get 'home/createUOD' => 'application#createUOD'
  post 'create_UOD' => 'application#create_UOD', :as => :create_UOD
  get 'resources/user_resources' => 'resources#user_resources', :as => :user_Resources
  get 'resources/view_resource/:id' => 'resources#view_resource', :as => :view_Resource
end
