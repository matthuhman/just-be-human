class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:home, :landing]

  def landing
    if current_user
      redirect_to :action => 'home'
    end
  end


  def home
    if current_user
      geopoint = Geopoint.find_by(zip: current_user.zip)
      @problems = Problem.near([geopoint.latitude, geopoint.longitude], 5)
      @roles = current_user.roles
    else
      redirect_to :action => 'landing'
    end
  end


  def my_problems
    @roles = current_user.roles
  end





  def costs
    

  end


  def help


  end


  def about_us


  end


  def donate


  end

end
