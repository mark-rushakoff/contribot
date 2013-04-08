Contribot::Application.routes.draw do
  root to: 'home#show'

  get '/login'  => 'sessions#create', as: :login
  get '/logout' => 'sessions#destroy', as: :logout

  get '/approved_users' => 'approved_users#index', as: :approved_users
  post '/pull_request_hook' => 'pull_request_hook#create', as: :pull_request_hook
end
