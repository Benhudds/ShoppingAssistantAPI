require "resque_web"
Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :slists do
    resources :iqps
  end
  
  resources :locations do
    resources :ipls
  end
  
  resources :listowners
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to:'users#create'
  
  post 'share', to: 'listowners#create'
  
  mount ResqueWeb::Engine => "/resque_web"
  root to: "locations#index"
end
