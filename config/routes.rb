Rails.application.routes.draw do
  resource :users, only: %i[create] # for signing up
  resources :sessions, only: %i[create destroy] # for logging in and out

  post '/login', to: 'users#login'
  get '/auto_login', to: 'users#auto_login'
end
