class PagesController < ApplicationController
  # before_action :authenticate_user!, except: [:map, :home]

  # # The landing screen is for unauthenticated users and includes
  # # a brief explanation of what the application does, how it works,
  # # and why it was built.
  # def landing
  #   if current_user
  #     redirect_to :action => 'home'
  #   end
  # end


  def home
    ############# 20201205 - commented out code from what was the "calendar" method is at bottom of file
  end


  def map
    @zip = map_params[:location_term]
    date = map_params[:cleanup_date]
    @cleanup_date = date ? date.to_date : Date.today
    @geopoint = Geopoint.find_by(zip: @zip)
    if !@geopoint
      @geopoint = Geopoint.find_by(zip: current_user.postal_code)
      flash.now[:alert] = "The zip code you searched for (#{map_params[:location_term]}) was not in our system."
    end

    if current_user
      @title_hash = current_user.opportunity_roles.map{ |r| [r.opportunity_id, r.title] }.to_h
      @roles = current_user.opportunity_roles
    else
      @title_hash = {}
      @roles = []
    end

    @cleanups = Cleanup.near([@geopoint.latitude, @geopoint.longitude], 20)
  end





  private

  def map_params
    params.permit(:location_term, :cleanup_date)
  end

  def donation_params
    params.require(:donation).permit(:email, :marketing)
  end

  def filter_params
    params.permit(:due_date)
  end

  def calendar_params
    params.permit(:week_offset, :postcode)
  end

  def to_json(opp_list)
    json = []
    opp_list.each do |opp|
      json << opp.to_cal_json
    end
    json
  end



  # # 20190815 - @mhuhman - this may not be necessary any more
  # def my_opportunities
  #   @roles = current_user.opportunity_roles
  # end

  # # This action is a static 'about us' page that just contains some text
  # # telling users about the company
  # def about_us
  # end

  # # This action is used to collect emails for future donation, marketing,
  # # and information-sharing purposes
  # def donate
  #   @donation = Donation.new(:donate => true, :marketing => true)
  # end

  # # This action is used to create a new "Donation" record and then redirects to
  # # the home or landing page
  # def donation_signup
  #   @donation = Donation.new(donation_params)

  #   respond_to do |format|
  #     if @donation.save
  #       format.html { redirect_to :action => 'home', notice: "Thank you for submitting your info! We'll be getting back to you soon with how you can help!" }
  #       format.json { render json: @donation, status: :created }
  #     else
  #       format.html { render :donate }
  #       format.json { render json: @donation.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end


    # offset = calendar_params[:week_offset] ? calendar_params[:week_offset].to_i : 0
    # if current_user
    #   @zip = calendar_params[:postcode] ? calendar_params[:postcode] : current_user.postal_code
    #   @geopoint = Geopoint.find_by(zip: @zip)

    #   if !@geopoint
    #     @geopoint = Geopoint.find_by(zip: current_user.postal_code)
    #     flash.now[:alert] = "The zip code you searched for (#{calendar_params[:postcode]}) was not valid"
    #   end
    # elsif calendar_params[:postcode]
    #   @zip = calendar_params[:postcode]
    #   @geopoint = Geopoint.find_by(zip: @zip)

    #   if !@geopoint
    #     zip = @zip
    #     @zip = nil
    #     @geopoint = nil
    #     flash.now[:alert] = "The zip code you entered (#{zip}) was not valid."
    #   end
    # end

    # # binding.pry

    # if @geopoint
    #   # week_start = Date.today.beginning_of_week
    #   # week_end = Date.today.end_of_week


    #   # @offset_end = week_end.next_day(7 * offset)
    #   # @offset_start = week_start.next_day(7 * offset)
    #   @opportunities = Opportunity.near([@geopoint.latitude, @geopoint.longitude], 25).where("cleanup_date >= ?", Date.today)
    #   # binding.pry
    # else
    #   @geopoint = nil
    # end




end
