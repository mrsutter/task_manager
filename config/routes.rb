Rails.application.routes.draw do
  scope module: :web do
    root to: 'home#index'
    resources :users, only: [:new, :create]

    namespace :user do
      resources :tasks do
        member do
          post :change_state
        end
      end
      resource :session, only: [:new, :create, :destroy]
    end

    namespace :admin do
      resources :users
    end
  end
end
