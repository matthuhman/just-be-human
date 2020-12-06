class LeaderboardController < ApplicationController
  # before_action :authenticate_user!
  # before_action :set_points, only: [:show, :index]

  # client = Aws::DynamoDB::Client.new

  # table_name = ENV["LEADERBOARD_DYNAMO_TABLE"]

  # def show
  # end

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



  private

    def set_points
      points = Point.get_points(current_user)
      @user_points = points.user_points
      @region_points = points.region_points
      @country_points = points.country_points
    end

end
