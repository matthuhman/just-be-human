class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:home, :landing]

  def landing
    if current_user
      redirect_to :action => 'home'
    end
  end


  def home
    if current_user
      @problems = Problem.where(zip: current_user.zip)
      @roles = current_user.roles
    else
      redirect_to :action => 'landing'
    end
  end


  def my_problems
    @roles = current_user.roles
  end

end
