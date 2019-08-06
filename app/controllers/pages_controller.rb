class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:home]

  def home
    @zipcode = ""
    if current_user
      @problems = Problem.where(zip: current_user.zip)
      @roles = current_user.roles
    else
      @problems = Problem.all
      @roles = nil
    end
  end


  def my_problems
    @roles = current_user.roles
  end

end
