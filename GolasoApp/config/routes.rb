Rails.application.routes.draw do
  resources :users, only: [:new, :create, :show] do
    resources :goals, only: [:new]
  end
  resource :session, only: [:new, :create, :destroy]
  resources :goals, except: [:new] do
    patch 'complete', on: :member
    patch 'cheer', on: :member
  end

  resources :comments, only: [:create, :destroy]
end
