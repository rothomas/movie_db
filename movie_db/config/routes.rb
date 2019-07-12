Rails.application.routes.draw do
  resources :movies, only: %I[index show]

  resources :genres, only: %I[index show]

  get '/extract', to: 'movies#extract'
end
