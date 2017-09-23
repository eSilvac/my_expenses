Rails.application.routes.draw do
  authenticated :user do
    root 'dashboard#index', as: :authenticated_root
  end
  root "pages#home"

  devise_for :users, controllers: {sessions: 'users/sessions'}

  resources :expenses
  resources :categories, only: [:new, :create, :destroy]
  resources :dashboard, only: [:index]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :expenses, except: [:show, :edit, :new]
    end
  end
end
