class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:home]

  def home
    if current_user
      @problems = Problem.where(zip: current_user.zip)
      @roles = current_user.roles
    else
      redirect_to problems_path
    end
  end


  def my_problems
    @roles = current_user.roles
  end

end
