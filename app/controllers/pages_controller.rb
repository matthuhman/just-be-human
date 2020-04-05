class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:map, :landing, :select, :costs, :help, :about_us, :donate, :donation_signup]

  # The landing screen is for unauthenticated users and includes
  # a brief explanation of what the application does, how it works,
  # and why it was built.
  def landing
    if current_user
      redirect_to :select
    end
  end


  def select
  end


  def map
    @category = nil
    @category_name = nil
    if map_params[:category]
      @category = map_params[:category].to_i
      @category_name = Category.opportunity_title_by_id(@category)
      if !@category_name
        @category = nil
      end
    end
    if current_user
      @zip = map_params[:location_term] ? map_params[:location_term] : current_user.postal_code
      @geopoint = Geopoint.find_by(zip: @zip)
      if !@geopoint
        @geopoint = Geopoint.find_by(zip: current_user.postal_code)
        flash.now[:alert] = "The zip code you searched for (#{map_params[:location_term]}) was not valid"
      end


      @my_opportunities = current_user.opportunities.where("completed = false").sort_by { |o| o.target_completion_date }
      @title_hash = current_user.opportunity_roles.map{ |r| [r.opportunity_id, r.title] }.to_h
      if @category
        @opportunities = Opportunity.near([@geopoint.latitude, @geopoint.longitude], 30).where("category = ?", @category) - @my_opportunities
      else
        @opportunities = Opportunity.near([@geopoint.latitude, @geopoint.longitude], 30) - @my_opportunities
      end

      @roles = current_user.opportunity_roles
    else
      postcode = request.location.postal_code
      if postcode == nil
        postcode = '80202'
        flash[:alert] = "Your browser may be preventing us from accessing your current location. Please allow location access - we do not save this information."
      end
      @my_opportunities = []
      @title_hash = {}
      @geopoint = Geopoint.find_by(zip: postcode)
      if @category
        @opportunities = Opportunity.near([@geopoint.latitude, @geopoint.longitude], 30).where("category = ?", @category)
      else
        @opportunities = Opportunity.near([@geopoint.latitude, @geopoint.longitude], 30)
      end
      @roles = []
    end
  end


  # This action is a static 'about us' page that just contains some text
  # telling users about the company
  def about_us
  end

  # This action is used to collect emails for future donation, marketing,
  # and information-sharing purposes
  def donate
    @donation = Donation.new(:donate => true, :marketing => true)
  end

  # This action is used to create a new "Donation" record and then redirects to
  # the home or landing page
  def donation_signup
    @donation = Donation.new(donation_params)

    respond_to do |format|
      if @donation.save
        format.html { redirect_to :action => 'landing', notice: "Thank you for submitting your info! We'll be getting back to you soon with how you can help!" }
        format.json { render json: @donation, status: :created }
      else
        format.html { render :donate }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
      end
    end
  end



  private

  def map_params
    params.permit(:location_term, :category)
  end

  def donation_params
    params.require(:donation).permit(:email, :marketing)
  end

  def filter_params
    params.permit(:due_date)
  end

end
