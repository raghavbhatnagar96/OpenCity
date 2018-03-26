Rails.application.routes.draw do
  #resources :resources
  resources :worlds
  devise_for :users, controllers: {registrations: "users/registrations", sessions: "users/sessions"}
  get 'resources/myResources' => 'resources#my_resources'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Some setup you must do manually if you haven't yet:

  # Ensure you have overridden routes for generated controllers in your routes.rb.
  # For example:

  #   Rails.application.routes.draw do
  #     devise_for :users, controllers: {
  #       sessions: 'users/sessions'
  #     }
  #   end
  root 'home#index'
  get 'home/createUOD' => 'application#createUOD'
  post 'create_UOD' => 'application#create_UOD', :as => :create_UOD
end
