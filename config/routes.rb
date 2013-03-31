Contribot::Application.routes.draw do
  root to: 'home#show'

  get '/login'  => 'sessions#create', as: :login
  get '/logout' => 'sessions#destroy', as: :logout

  get '/approved_users' => 'approved_users#index', as: :approved_users
end
