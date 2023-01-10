Rails.application.routes.draw do
  scope '/admin' do
    resources :users
    get '/notifications', to: 'users#notifications', as: 'admin_notifications'
    put '/users/:id/approve', to: 'users#approve', as: 'admin_user_approve'
  end
  devise_for :users
  root 'pages#home'
  get '/users/:id/portfolio', to: 'users#portfolio', as: 'user_portfolio'
  resources :stocks do
    resources :transactions, only: %i[create new]
  end
  resources :transactions, only: %i[index]
end
