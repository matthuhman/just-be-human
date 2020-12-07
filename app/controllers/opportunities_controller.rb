class OpportunitiesController < ApplicationController
  respond_to :html, :xml, :json

  rescue_from ActionController::InvalidAuthenticityToken, with: :handle_old_token


  before_action :set_opportunity, only: [:show, :edit, :update, :destroy, :followers, :complete, :uncomplete, :follow, :unfollow, :sign]
  before_action :authenticate_user!, except: [:show]

  before_action :set_time_options, only: [:create, :edit, :new]


  # GET /opportunities/1
  # GET /opportunities/1.json
  def show
    if current_user
      @role = OpportunityRole.find_by(user_id: current_user.id, opportunity_id: @opportunity.id)
      @is_mod = current_user.is_mod?(@opportunity.id)
      @is_admin = current_user.is_admin?(@opportunity.id)
    end
  end

  #
  # GET /opportunities/new
  def new
    @coord_string = params[:coordinates]
    raw_coords = JSON.parse @coord_string
    coords = []
    raw_coords.each do |coord|
      coords.push Coordinate.new(lat: coord['lat'], lng: coord['lng'])
    end
    @opportunity = Opportunity.new(coordinates: coords)
  end

  #
  # GET /opportunities/1/edit
  def edit
  end


  # POST /opportunities
  # POST /opportunities.json
  def create
    coord_string = opportunity_params.extract! :coordinates
    raw_coords = JSON.parse coord_string[:coordinates]
    coords = []
    raw_coords.each do |coord|
      coords.push Coordinate.new(lat: coord['lat'], lng: coord['lng'])
    end
    @opportunity = Opportunity.new(opportunity_params.except(:coordinates))
    @opportunity.user = current_user


    @opportunity.latitude = coords.first.lat
    @opportunity.longitude = coords.first.lng



    ################# 20201205 - we're going to get rid of roles, actually. You just have a "home zone"

    # @role = OpportunityRole.create
    # @role.user_id = current_user.id
    # @role.level = 1
    # @role.title = "Leader"


    respond_to do |format|
      if @opportunity.save
        coords.each do |c|
          c.opportunity_id = @opportunity.id
          if !c.save
            format.html {render :new }
            format.json { render json: @role.errors, status: :unprocessable_entity}
          end
        end
        format.html { redirect_to @opportunity, notice: 'Opportunity and role was successfully created.' }
        format.json { render :show, status: :created, location: @opportunity }
      else
        format.html {render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity}
      end
    end
  end


  # PATCH/PUT /opportunities/1
  # PATCH/PUT /opportunities/1.json
  def update
    respond_to do |format|
      if @opportunity.update(opportunity_params)
        format.html { redirect_to @opportunity, notice: 'Opportunity was successfully updated.' }
        format.json { render :show, status: :ok, location: @opportunity }
      else
        format.html { render :edit }
        format.json { render json: @opportunity.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /opportunities/1
  # DELETE /opportunities/1.json
  def destroy
      respond_to do |format|
        format.html { redirect_to opportunities_url, notice: 'Your cleanup zone was successfully deleted.' }
        format.json { head :no_content }
      end
  end









##################################################
#####################
#####################
#####################
#####################
##################### =>  20201205 abandoned
#####################
#####################
#####################
#####################
#####################
##################################################



    ################# 20201205 - we're going to get rid of roles, actually. You just have a "home zone"
    ################# this is the old version of the respond_to in the create method
    # respond_to do |format|
    #   if @opportunity.save
    #     @role.opportunity_id = @opportunity.id
    #     if @role.save
    #       coords.each do |c|
    #         c.opportunity_id = @opportunity.id
    #         if !c.save
    #           format.html {render :new }
    #           format.json { render json: @role.errors, status: :unprocessable_entity}
    #         end
    #       end
    #       format.html { redirect_to @opportunity, notice: 'Opportunity and role was successfully created.' }
    #       format.json { render :show, status: :created, location: @opportunity }
    #     else
    #       format.html {render :new }
    #       format.json { render json: @role.errors, status: :unprocessable_entity}
    #     end
    #   else
    #     format.html { render :new }
    #     format.json { render json: @opportunity.errors, status: :unprocessable_entity }
    #   end
    # end

    ################# 20201205 - we're going to get rid of roles, actually. You just have a "home zone"
    ################# this is the old version of the destroy method
      # if @opportunity.opportunity_roles.size > 1
      #   # sorted_roles = @opportunity.opportunity_roles.sort_by { |r| [r.level, r.created_at] }
      #   # curr_leader = sorted_roles.first

      #   # sorted_roles.delete_at(0)

      #   # new_leader = sorted_roles.first

      #   # new_leader.level = 1
      #   # new_leader.title = "Leader"
      #   # new_leader.save

      #   # @opportunity.user_id = new_leader.user_id
      #   # @opportunity.save

      #   # curr_leader.level = 3
      #   # curr_leader.title = "Volunteer"
      #   # curr_leader.save

      #   format.html { redirect_to @opportunity, alert: "You are no longer the leader of this Opportunity." }
      #   format.json { render :show, status: :ok, location: @opportunity }
      # else
      #   @opportunity.destroy
      #   format.html { redirect_to "/", alert: "You were the only user, the Opportunity has been deleted." }
      # end
      # @opportunity.destroy


  # def followers
  #   @role = OpportunityRole.find_by(user_id: current_user.id, opportunity_id: @opportunity.id)
  #   @is_admin = current_user.is_admin?(@opportunity.id)
  #   @is_volunteer = current_user.is_volunteer?(@opportunity.id)
  #   @is_follower = current_user.is_follower?(@opportunity.id)
  # end


  # #
  # # GET /opportunities/follow
  # # takes opportunity_id query param
  # def follow
  #   respond_to do |format|
  #     if Role.follow_opportunity(current_user.id, @opportunity.id)

  #       format.html { redirect_to @opportunity, notice: 'You have successfully followed this opportunity.' }
  #       format.json { render :show, status: :created, location: @opportunity }
  #     else
  #       format.html { redirect_to @opportunity, notice: 'You have not followed this opportunity successfully' }
  #       format.json { render :show, status: :unprocessable_entity, location: @opportunity }
  #     end
  #   end
  # end

  # #
  # # GET /opportunities/unfollow
  # # takes opportunity_id query param
  # def unfollow
  #   respond_to do |format|
  #     if Role.unfollow_opportunity(current_user.id, @opportunity.id)
  #       format.html { redirect_to @opportunity, notice: "You have unfollowed this opportunity" }
  #       format.json { render :show, status: :ok, location: @opportunity}
  #     else
  #       format.html { redirect_to @opportunity, alert: "You cannot unfollow a opportunity without a role."}
  #       format.json { render :show, status: :unprocessable_entity, location: @opportunity}
  #     end
  #   end
  # end

  # def rsvp
  #   role = OpportunityRole.find(params[:rsvp][:role_id])

  #   oppo = role.opportunity
  #   respond_to do |format|
  #     if role && role.user == current_user
  #       rsvp = params[:rsvp]

  #       if Role.rsvp(current_user, role, rsvp)
  #         format.html { redirect_to role.opportunity, notice: "You have RSVP'd successfully!" }
  #         format.json { render :show, status: :ok, location: role.opportunity }
  #       else
  #         format.html { redirect_to role.opportunity, alert: "An unexpected error occurred." }
  #         format.json { render :show, status: :unprocessable_entity, location: role.opportunity }
  #       end
  #     else
  #       format.html { redirect_to role.opportunity, alert: "That role does not exist or you cannot edit it." }
  #       format.json { render :show, status: :bad_request, location: role.opportunity }
  #     end
  #   end
  # end

  # #
  # # GET /opportunities/leader
  # # takes opportunity_id and target_user_id query params
  # def leader
  #   @opportunity = Opportunity.find(promotion_params[:opportunity_id])
  #   respond_to do |format|
  #     if (current_user == @opportunity.user)
  #       if Role.set_opp_leader(current_user.id, params[:target_user_id], @opportunity.id)
  #         format.html { redirect_to @opportunity, notice: "User promoted to Leader." }
  #         format.json { render :show, status: :ok, location: @opportunity}
  #       else
  #         format.html { redirect_to @opportunity, notice: "User was not promoted due to an internal error. It has been logged for investigation." }
  #         format.json { render :show, status: :unprocessable_entity, location: @opportunity}
  #       end
  #     else
  #       format.html { redirect_to @opportunity, alert: "You do not have administrative permissions for this opportunity."}
  #       format.json { render :show, status: :forbidden, location: @opportunity }
  #     end
  #   end
  # end


  # #
  # # GET /opportunities/promote
  # # takes opportunity_id and target_user_id query params
  # def promote_user
  #   @opportunity = Opportunity.find(promotion_params[:opportunity_id])
  #   respond_to do |format|
  #     if (current_user == @opportunity.user)
  #       if Role.make_opp_supervisor(params[:target_user_id], @opportunity.id)
  #         format.html { redirect_to @opportunity, notice: "User promoted to Supervisor." }
  #         format.json { render :show, status: :ok, location: @opportunity}
  #       else
  #         format.html { redirect_to @opportunity, notice: "User was not promoted due to an internal error. It has been logged for investigation." }
  #         format.json { render :show, status: :unprocessable_entity, location: @opportunity}
  #       end
  #     else
  #       format.html { redirect_to @opportunity, alert: "You do not have administrative permissions for this opportunity."}
  #       format.json { render :show, status: :forbidden, location: @opportunity }
  #     end
  #   end
  # end

  # #
  # # GET /opportunities/demote
  # # takes in a
  # def demote_user
  #   @opportunity = Opportunity.find(promotion_params[:opportunity_id])
  #   target_user_id = promotion_params[:target_user_id]

  #   respond_to do |format|
  #     if (current_user == @opportunity.user || current_user == target_user_id)
  #       ## remove the target user as a supervisor
  #       if Role.remove_opp_supervisor(target_user_id, @opportunity.id)
  #         if (target_user_id != current_user.id)
  #           format.html { redirect_to @opportunity, notice: "User is no longer a Supervisor." }
  #           format.json { render :show, status: :ok, location: @opportunity}
  #         else
  #           format.html { redirect_to @opportunity, notice: "You have stepped down as a Supervisor." }
  #           format.json { render :show, status: :ok, location: @opportunity}
  #         end
  #       else
  #         format.html { redirect_to @opportunity, alert: "User was not demoted due to an internal error. It has been logged for investigation." }
  #         format.json { render :show, status: :unprocessable_entity, location: @opportunity }
  #       end
  #     else
  #       format.html { redirect_to @opportunity, alert: "You do not have administrative permissions for this opportunity."}
  #       format.json { render :show, status: :forbidden, location: @opportunity }
  #     end
  #   end
  # end

  # def complete
  #   completion_post = Post.new(opportunity_id: @opportunity.id, completion_post: true, title: "We did it!", content: "Put some cool pictures of what you did in here!", user_id: current_user.id)
  #   respond_to do |format|
  #     if current_user.is_admin?(@opportunity.id)
  #       if @opportunity.can_complete?
  #         if @opportunity.mark_complete
  #           completion_post.save
  #           format.html { redirect_to edit_post_path(completion_post) }
  #           format.json { render :new, status: :ok, location: completion_post }
  #         else
  #           format.html { redirect_to @opportunity, alert: "An unexpected error occurred." }
  #           format.json { render :show, status: :unprocessable_entity, location: @opportunity }
  #         end
  #       else
  #         format.html { redirect_to @opportunity, alert: "This opportunity cannot be completed yet. Make sure all Requirements are complete!" }
  #         format.json { render :show, status: :bad_request, location: @opportunity }
  #       end
  #     else
  #       format.html { redirect_to @opportunity, alert: "You do not have permission to do this." }
  #       format.json { render :show, status: :forbidden, location: @opportunity }
  #     end
  #   end
  # end

  # def uncomplete
  #   respond_to do |format|
  #     if current_user.is_admin?(@opportunity.id)
  #       if !@opportunity.completed
  #         if @opportunity.mark_uncompleted
  #           format.html { redirect_to @opportunity, notice: "This opportunity is open again." }
  #           format.json { render :new, status: :ok, location: @opportunity }
  #         else
  #           format.html { redirect_to @opportunity, alert: "An unexpected error occurred." }
  #           format.json { render :show, status: :unprocessable_entity, location: @opportunity }
  #         end
  #       else
  #         format.html { redirect_to @opportunity, alert: "This opportunity cannot be completed yet. Make sure all Requirements are complete!" }
  #         format.json { render :show, status: :bad_request, location: @opportunity }
  #       end
  #     else
  #       format.html { redirect_to @opportunity, alert: "You do not have permission to do this." }
  #       format.json { render :show, status: :forbidden, location: @opportunity }
  #     end
  #   end
  # end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_opportunity
    @opportunity = Opportunity.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def opportunity_params
    params.require(:opportunity).permit(:title, :description, :defined, :address, :coordinates, :cleanup_date, :cleanup_time, :cleanup_duration, :postal_code, :country, :volunteers_required, :status, :time_zone)
  end

  def promotion_params
    params.permit(:opportunity_id, :target_user_id)
  end

  def rsvp_params
    params.require(:rsvp).permit(:role_id, :additional_vols)
  end

  def set_time_options
    @time_options = ["Weekly", "Bi-weekly", "Monthly", "Annually"]
  end


  # TODO: This needs to get sorted out, this is a huge pain in the ass
  def handle_old_token
    ReportedError.report('RSVP', "unexpected invalid authenticity token", 100)
    redirect_back fallback_location: @opportunity,
      alert: 'Please refresh your page and try again'
  end


  def send_follow_email


  end
end
