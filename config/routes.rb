Rails.application.routes.draw do
  devise_for :users
  
  root to: "questions#index"

  resources :questions, only: %i[index show new create update destroy] do
    resources :attachments, shallow: true, only: :destroy
    resources :answers, shallow: true, only: %i[show create update destroy] do
      patch :best
    end
  end
end
