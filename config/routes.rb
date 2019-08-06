Rails.application.routes.draw do
  resources :comments
  root to: 'pages#home'

  get 'registrations/sign_up_params'
  get 'registrations/account_update_params'

  get '/my_problems' => 'pages#my_problems'

  get '/problems/follow' => 'problems#follow'
  get '/problems/unfollow' => 'problems#unfollow'
  get '/problems/promote_user' => 'problems#promote_user'
  get '/problems/demote_user' => 'problems#demote_user'
  

  resources :problems, :comments
  
  devise_for :users, :controllers => { registrations: 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
  