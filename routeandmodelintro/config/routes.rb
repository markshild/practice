BlankProject::Application.routes.draw do
  resources :users, only: [:update, :show, :index, :destroy, :create] do
    resources :contacts, only: :index
  end

  resources :contacts, only: [:update, :show, :destroy, :create]
  resources :contact_shares, only: [:destroy, :create]

end
