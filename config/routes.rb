Rails.application.routes.draw do
  get 'sessions/new'

  get 'users/new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'recipes#index'

  resources :recipes

  #probably will want to restrict the routes later
  resources :ingredients

resources :meals do 
   collection do
      get 'planner'
    end 
    match :batch_create, via: [:post], on: :collection
    collection do
      get 'pantry'
    end
     match :recipes_using_pantry, via: [:get], on: :collection
  end

  get  '/signup',  to: 'users#new'
  get '/charts', to: 'users#charts'

  resources :users 

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
end