class PagesController < ApplicationController
  def home
    @zipcode = ""
    if current_user
      @problems = Problem.where(zip: current_user.zip)
    else
      @problems = Problem.all
    end
  end
end
