Rails.application.routes.draw do
  resources :questions, only: %i[show new create]
end
