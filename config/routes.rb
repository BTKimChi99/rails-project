Rails.application.routes.draw do
  root 'home#index'

  get 'home', to: 'home#index', as: :home
  get 'home/edit', to: 'home#edit', as: :edit_home
  patch 'home', to: 'home#update'

  get 'login', to: 'sessions#new', as: :login
  post 'login', to: 'sessions#create'

  delete 'logout', to: 'sessions#destroy', as: :logout

  get 'register', to: 'registrations#new', as: :register
  post 'register', to: 'registrations#create'

  get 'password_resets/new', to: 'password_resets#new', as: :new_password_reset
  post 'password_resets', to: 'password_resets#create', as: :password_resets
  get 'password_resets/edit', to: 'password_resets#edit', as: :edit_password_reset
  patch 'password_resets', to: 'password_resets#update'

  namespace :admin do
    root 'dashboard#index'
    resources :products
    resources :users, only: [:index, :edit, :update, :destroy]
  end

  namespace :admin do
      resources :orders do
        member do
          patch :assign   # /admin/orders/:id/assign
          patch :start_delivery
          patch :mark_delivered
          patch :cancel
        end
      end
    end

    namespace :shipper do
      resources :orders, only: [:index, :show, :update]  # update để đổi trạng thái
    end

end
