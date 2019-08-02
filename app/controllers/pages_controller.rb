class PagesController < ApplicationController
  def home
    @zipcode = ""
    if current_user
      @zipcode = current_user.zip
    else
      @zipcode = request.location.zipcode
    end

    @problems = Problem.where(zip: @zipcode)
  end
end
