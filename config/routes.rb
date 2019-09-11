Rails.application.routes.draw do

  root to: 'pages#home'

  get '/landing' => 'pages#landing'

  get '/costs' => 'costs#display'
  get '/aboutus' => 'pages#about_us'
  get '/donate' => 'pages#donate'
  post '/donate' => 'pages#donation_signup'

  get 'registrations/sign_up_params'
  get 'registrations/account_update_params'

  get '/contact/request' => 'users#request_contact_info'
  get '/contact/response' => 'users#respond_contact_info'

  get '/my_opportunities' => 'pages#my_opportunities'

  get '/opportunities/follow' => 'opportunities#follow'
  get '/opportunities/unfollow' => 'opportunities#unfollow'
  get '/opportunities/promote_user' => 'opportunities#promote_user'
  get '/opportunities/demote_user' => 'opportunities#demote_user'
  get '/opportunities/followers' => 'opportunities#followers'

  get '/requirements/participate' => 'requirements#participate'
  get '/requirements/cancel' => 'requirements#cancel_participation'

  resources :personal_messages, only: [:create]
  resources :conversations, only: [:index, :show]
  resources :personal_messages, only: [:new, :create]


  resources :opportunities, :comments, :posts, :requirements

  devise_for :users, :controllers => { registrations: 'registrations' }



end
