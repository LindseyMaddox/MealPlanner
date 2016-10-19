Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :recipes

#may only want to provide routes for index and planner
#how do we only show something if they've just saved it (i.e. if they point a url to a recipe, it redirects?)
  resources :meal_plans do 
   collection do
      get 'planner'
    end
    match :batch_create, via: [:post], on: :collection
  end
end
