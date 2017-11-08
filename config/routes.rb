Rails.application.routes.draw do
  get 'welcome/index'

  resources :topics

  resources :posts

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", confirmations: 'confirmations' }

  root 'welcome#index'

end
