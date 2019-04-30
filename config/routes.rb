Rails.application.routes.draw do
  devise_for :users
  
  root to: "questions#index"

  resources :questions, only: %i[index show new create update destroy] do
    resources :answers, shallow: true, only: %i[create update destroy]
  end
end
