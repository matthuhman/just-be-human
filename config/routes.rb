Rails.application.routes.draw do

  root to: 'pages#home'

  get '/landing' => 'pages#landing'
  get '/home' => 'pages#home'
  get '/costs' => 'costs#display'
  get '/aboutus' => 'pages#about_us'
  get '/donate' => 'pages#donate'
  post '/donate' => 'pages#donation_signup'

  get 'registrations/sign_up_params'
  get 'registrations/account_update_params'

  get '/my_opportunities' => 'pages#my_opportunities'

  get '/opportunities/follow' => 'opportunities#follow'
  get '/opportunities/unfollow' => 'opportunities#unfollow'
  get '/opportunities/leader' => 'opportunities#leader'
  get '/opportunities/promote_user' => 'opportunities#promote_user'
  get '/opportunities/demote_user' => 'opportunities#demote_user'
  get '/opportunities/followers' => 'opportunities#followers'
  get '/opportunities/complete' => 'opportunities#complete'
  get '/opportunities/uncomplete' => 'opportunities#uncomplete'
  post 'opportunities/rsvp' => 'opportunities#rsvp'

# 20200203 - remove requirements from Detrashers
  # get '/requirements/participate' => 'requirements#participate'
  # get '/requirements/cancel' => 'requirements#cancel_participation'
  # get '/requirements/promote' => 'requirements#promote_leader'
  # get '/requirements/demote' => 'requirements#remove_leader'
  # get '/requirements/complete' => 'requirements#mark_complete'
  # get '/requirements/incomplete' => 'requirements#mark_incomplete'
  # get '/requirements/define' => 'requirements#mark_defined'

  get '/notifications/mark_as_read' => 'notifications#mark_as_read'

  post '/signatures/callbacks' => 'signatures#callbacks'

  resources :conversations, only: [:index, :show]
  resources :personal_messages, only: [:new, :create]

    #20200211 - punting on signatures for sure, that's just more work than I
    # can take on right now
  resources :opportunities, :comments, :posts     #, :signatures
  resources :notifications, only: [:index, :mark_as_read]

  devise_for :users, :controllers => { registrations: 'registrations' }



end
