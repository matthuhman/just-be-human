class HelloSignController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:callbacks]


  def callbacks
    render json: 'Hello API Event Received', status: 200
  end
end
