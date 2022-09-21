Rails.application.routes.draw do
  post 'authenticate', to: 'authentication#authenticate'

  defaults format: :json do
    resources :users, only: [:index, :create]
    resources :posts, only: [:index, :create, :show, :update, :destroy]
  end
end
