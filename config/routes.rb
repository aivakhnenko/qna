Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  
  root to: "questions#index"

  concern :votable do
    post :vote, on: :member
  end
  concern :commentable do
    post :comment, on: :member
  end

  resources :questions, only: %i[index show new create update destroy], concerns: [:votable, :commentable] do
    resources :attachments, shallow: true, only: :destroy
    resources :answers, shallow: true, only: %i[show create update destroy], concerns: [:votable, :commentable] do
      patch :best
    end
  end
  resources :links, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'
end
