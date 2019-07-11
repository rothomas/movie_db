Rails.application.routes.draw do
  resources :movies, only: %I[index show]
end
