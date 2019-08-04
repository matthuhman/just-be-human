Rails.application.routes.draw do
  resources :comments
  root to: 'pages#home'

  get 'registrations/sign_up_params'
  get 'registrations/account_update_params'
  

  resources :problems, :comments
  
  devise_for :users, :controllers => { registrations: 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
  