Rails.application.routes.draw do
  root 'recipes#index'

  resources :recipes

#may only want to provide routes for index and planner

  resources :meal_plans do 
   collection do
      get 'planner'
    end
    match :batch_create, via: [:post], on: :collection
  end
end
