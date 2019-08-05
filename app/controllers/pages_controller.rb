class PagesController < ApplicationController
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
end
