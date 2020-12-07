class PagesController < ApplicationController

  def home
    ############# 20201205 - commented out code from what was the "calendar" method is at bottom of file
    if current_user && current_user.postal_code
      redirect_to '/map?location_term=' + current_user.postal_code
    end
  end


  def map
    @location_term = map_params[:location_term]

    @latLng = nil
    if (map_params[:lat] && map_params[:lng])
      @latLng = [map_params[:lat], map_params[:lng]]
    end
    @geopoint = Geopoint.find_by(zip: @location_term)
    @cleanups = nil
    sixty_days_ago = Date.today - 60.days
    if @geopoint
      @cleanups = Cleanup.near([@geopoint.latitude, @geopoint.longitude], 20).where("created_at > :date", date: sixty_days_ago)
    elsif @location_term
      results = Geocoder.search(@location_term)
      @location = results.first.coordinates

      @cleanups = Cleanup.near(@location_term, 20).where("created_at > :date", date: sixty_days_ago)
    else
      @cleanups = Cleanup.near([@latLng[0], @latLng[1]], 20).where("created_at > :date", date: sixty_days_ago)
    end

    @cleanup_json = @cleanups.to_json.html_safe
  end

  private

  def map_params
    params.permit(:location_term, :cleanup_date, :lat, :lng)
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
