class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:home, :landing, :costs, :help, :about_us, :donate, :donation_signup]

  def landing
    if current_user
      redirect_to :action => 'home'
    end
  end


  def home
    if current_user
      @zip = location_params[:location_term] ? location_params[:location_term] : current_user.zip 
      @geopoint = Geopoint.find_by(zip: @zip)
      if !@geopoint
        @geopoint = Geopoint.find_by(zip: current_user.zip)
        flash.now[:alert] = "The zip code you searched for (#{location_params[:location_term]}) was not valid"
      end
      @problems = Problem.near([@geopoint.latitude, @geopoint.longitude], 5)
      @roles = current_user.roles
    else
      redirect_to :action => 'landing'
    end
  end


  def my_problems
    @roles = current_user.roles
  end


  def help


  end


  def about_us


  end


  def donate
    @donation = Donation.new
  end


  def donation_signup
    @donation = Donation.create(donation_params)

    respond_to do |format|
      if @donation.save
        format.html { redirect_to :home, notice: "Thank you for submitting your info! We'll be getting back to you soon with how you can help!" }
        format.json { render json: @donation, status: :created }
      else
        binding.pry
        format.html { render :donate }
        format.json { render json: @donation.errors, status: :unprocessable_entity }

      end
    end
  end



  private

    def location_params
      params.permit(:location_term)
    end

    def donation_params
      params.require(:donation).permit(:email, :donate, :marketing, :volunteer)
    end

end
