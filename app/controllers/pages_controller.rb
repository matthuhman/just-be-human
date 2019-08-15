class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:home, :landing, :costs, :help, :about_us, :donate, :donation_signup]

  # The landing screen is for unauthenticated users and includes
  # a brief explanation of what the application does, how it works,
  # and why it was built.
  def landing
    if current_user
      redirect_to :action => 'home'
    end
  end

  # This action represents the main interface for the application.
  # Uses the google maps JS integration to display @problems on the map
  # If there is no user, it redirects to the landing screen
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

  # 20190815 - @mhuhman - this may not be necessary any more
  def my_problems
    @roles = current_user.roles
  end

  # This action is a static 'about us' page that just contains some text
  # telling users about the company
  def about_us
  end

  # This action is used to collect emails for future donation, marketing,
  # and information-sharing purposes
  def donate
    @donation = Donation.new(:donate => true, :marketing => true, :volunteer => true)
  end

  # This action is used to create a new "Donation" record and then redirects to
  # the home or landing page
  def donation_signup
    @donation = Donation.create(donation_params)

    respond_to do |format|
      if @donation.save
        format.html { redirect_to :action => 'home', notice: "Thank you for submitting your info! We'll be getting back to you soon with how you can help!" }
        format.json { render json: @donation, status: :created }
      else
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
