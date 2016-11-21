Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'recipes#index'

  resources :recipes

resources :meal_plans do 
   collection do
      get 'planner'
    end
    match :batch_create, via: [:post], on: :collection
  end
end