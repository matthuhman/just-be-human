Rails.application.routes.draw do

  root to: 'pages#home'

  get '/landing' => 'pages#landing'
  
  get '/costs' => 'costs#display'
  get '/aboutus' => 'pages#about_us'
  get '/donate' => 'pages#donate'
  get '/help' => 'pages#help'

  get 'registrations/sign_up_params'
  get 'registrations/account_update_params'

  get '/my_problems' => 'pages#my_problems'

  get '/problems/follow' => 'problems#follow'
  get '/problems/unfollow' => 'problems#unfollow'
  get '/problems/promote_user' => 'problems#promote_user'
  get '/problems/demote_user' => 'problems#demote_user'

  get '/milestones/participate' => 'milestones#participate'
  get '/milestones/cancel' => 'milestones#cancel_participation'
  

  resources :problems, :comments, :posts, :milestones
  
  devise_for :users, :controllers => { registrations: 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
  