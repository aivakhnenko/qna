require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |user| user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks', registrations: 'registrations' }
  devise_scope :user do
    patch 'users/:id', to: 'registrations#update_email', as: 'user'
  end

  root to: "questions#index"

  concern :votable do
    post :vote, on: :member
  end
  concern :commentable do
    post :comment, on: :member
  end

  resources :questions, only: %i[index show new create update destroy], concerns: [:votable, :commentable] do
    resources :attachments, shallow: true, only: :destroy
    resources :subscriptions, shallow: true, only: %i[create destroy]
    resources :answers, shallow: true, only: %i[show create update destroy], concerns: [:votable, :commentable] do
      patch :best
    end
  end
  resources :links, only: :destroy
  resources :rewards, only: :index

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions, only: %i[index show create update destroy] do
        resources :answers, shallow: true, only: %i[index show create update destroy]
      end
    end
  end

  mount ActionCable.server => '/cable'
end
