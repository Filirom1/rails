Rails.application.routes.draw do
  get 'home/index'
  root "home#index"
  get '/auth/:provider/callback', to: 'sessions#create'


  resources :repositories

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
