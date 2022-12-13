Rails.application.routes.draw do
  scope '/admin' do
    resources :users
  end
  devise_for :users
  root 'pages#home'
end
