class HelloSignController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:callbacks]

##################################################
#####################
#####################
#####################
#####################
##################### =>  20201205 abandoned
#####################
#####################
#####################
#####################
#####################
##################################################


  # def callbacks
  #   render json: 'Hello API Event Received', status: 200
  # end
end
