class OpportunitiesController < ApplicationController
  respond_to :html, :xml, :json


  before_action :set_opportunity, only: [:show, :edit, :update, :destroy, :followers, :complete, :uncomplete, :follow, :unfollow]
  before_action :authenticate_user!, except: [:show]

  before_action :set_time_options, only: [:create, :edit, :new]


  # GET /opportunities/1
  # GET /opportunities/1.json
  def show
    @requirements = @opportunity.requirements.sort_by(&:priority).sort_by(&:target_completion_date)
    if current_user
      @role = OpportunityRole.find_by(user_id: current_user.id, opportunity_id: @opportunity.id)
      @is_mod = current_user.is_mod?(@opportunity.id)
      @is_admin = current_user.is_admin?(@opportunity.id)
    end
  end

  # GET /opportunities/new
  def new
    @opportunity = Opportunity.new(target_completion_date: Date.tomorrow)
    @categories = Category.opportunity_titles
  end

  # GET /opportunities/1/edit
  def edit
    @categories = Category.opportunity_titles
  end


  # POST /opportunities
  # POST /opportunities.json
  def create
    @categories = Category.opportunity_titles
    @opportunity = Opportunity.new(opportunity_params)
    @opportunity.user = current_user

    if !@opportunity.postal_code
      geopoint = Geopoint.find_by(zip: @opportunity.postal_code)
      if geopoint
        @opportunity.latitude = geopoint.latitude
        @opportunity.longitude = geopoint.longitude
      else
        puts "GEOPOINT NOT FOUND FOR POSTCODE: #{@opportunity.postal_code}"
      end
    end

    @role = OpportunityRole.create
    @role.user_id = current_user.id
    @role.level = 1
    @role.title = "Leader"

    respond_to do |format|
      if @opportunity.save
        @role.opportunity_id = @opportunity.id
        if @role.save
          format.html { redirect_to @opportunity, notice: 'Opportunity and role was successfully created.' }
          format.json { render :show, status: :created, location: @opportunity }
        else
          format.html {render :new }
          format.json { render json: @role.errors, status: :unprocessable_entity}
        end
      else
        format.html { render :new }
        format.json { render json: @opportunity.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /opportunities/1
  # PATCH/PUT /opportunities/1.json
  def update
    @categories = Category.opportunity_titles
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
      if @opportunity.opportunity_roles.size > 1
        sorted_roles = @opportunity.opportunity_roles.sort_by { |r| [r.level, r.created_at] }
        curr_leader = sorted_roles.first

        sorted_roles.delete_at(0)

        new_leader = sorted_roles.first

        new_leader.level = 1
        new_leader.title = "Leader"
        new_leader.save

        @opportunity.user_id = new_leader.user_id
        @opportunity.save

        curr_leader.level = 3
        curr_leader.title = "Volunteer"
        curr_leader.save

        format.html { redirect_to @opportunity, alert: "You are no longer the leader of this Opportunity." }
        format.json { render :show, status: :ok, location: @opportunity }
      else
        @opportunity.destroy
        format.html { redirect_to "/", alert: "You were the only user, the Opportunity has been deleted." }
      end
      # @opportunity.destroy
      # respond_to do |format|
      #   format.html { redirect_to opportunities_url, notice: 'Opportunity was successfully destroyed.' }
      #   format.json { head :no_content }
      # end
    end
  end

  def followers
    @role = OpportunityRole.find_by(user_id: current_user.id, opportunity_id: @opportunity.id)
    @is_admin = current_user.is_admin?(@opportunity.id)
    @is_volunteer = current_user.is_volunteer?(@opportunity.id)
  end


  #
  # GET /opportunities/follow
  # takes opportunity_id query param
  def follow
    respond_to do |format|
      if Role.follow_opportunity(current_user.id, @opportunity.id)
        format.html { redirect_to @opportunity, notice: 'You have successfully followed this opportunity.' }
        format.json { render :show, status: :created, location: @opportunity }
      else
        format.html { redirect_to @opportunity, notice: 'You have not followed this opportunity successfully' }
        format.json { render :show, status: :unprocessable_entity, location: @opportunity }
      end
    end
  end

  #
  # GET /opportunities/unfollow
  # takes opportunity_id query param
  def unfollow
    respond_to do |format|
      if (Role.unfollow_opportunity(current_user.id, @opportunity.id))
        format.html { redirect_to @opportunity, notice: "You have unfollowed this opportunity" }
        format.json { render :show, status: :ok, location: @opportunity}
      else
        format.html { redirect_to @opportunity, alert: "You cannot unfollow a opportunity without a role."}
        format.json { render :show, status: :unprocessable_entity, location: @opportunity}
      end
    end
  end


  #
  # GET /opportunities/promote
  # takes opportunity_id and target_user_id query params
  def promote_user
    @opportunity = Opportunity.find(promotion_params[:opportunity_id])
    respond_to do |format|
      if (current_user == @opportunity.user)
        if Role.make_supervisor(params[:target_user_id], @opportunity.id)
          format.html { redirect_to @opportunity, notice: "User promoted to Supervisor." }
          format.json { render :show, status: :ok, location: @opportunity}
        else
          format.html { redirect_to @opportunity, notice: "User was not promoted due to an internal error. It has been logged for investigation." }
          format.json { render :show, status: :unprocessable_entity, location: @opportunity}
        end
      else
        format.html { redirect_to @opportunity, alert: "You do not have administrative permissions for this opportunity."}
        format.json { render :show, status: :forbidden, location: @opportunity }
      end
    end
  end

  #
  # GET /opportunities/demote
  # takes in a
  def demote_user
    @opportunity = Opportunity.find(promotion_params[:opportunity_id])
    target_user_id = promotion_params[:target_user_id]

    respond_to do |format|
      if (current_user == @opportunity.user || current_user == target_user_id)
        ## remove the target user as a supervisor
        if Role.remove_supervisor(target_user_id, @opportunity.id)
          if (target_user_id != current_user.id)
            format.html { redirect_to @opportunity, notice: "User is no longer a Supervisor." }
            format.json { render :show, status: :ok, location: @opportunity}
          else
            format.html { redirect_to @opportunity, notice: "You have stepped down as a Supervisor." }
            format.json { render :show, status: :ok, location: @opportunity}
          end
        else
          format.html { redirect_to @opportunity, alert: "User was not demoted due to an internal error. It has been logged for investigation." }
          format.json { render :show, status: :unprocessable_entity, location: @opportunity }
        end
      else
        format.html { redirect_to @opportunity, alert: "You do not have administrative permissions for this opportunity."}
        format.json { render :show, status: :forbidden, location: @opportunity }
      end
    end
  end

  def complete
    completion_post = Post.new(postable_id: @opportunity.id, postable_type: "Opportunity", completion_post: true, title: "We did it!", content: "Put some cool pictures of what you did in here!", user_id: current_user.id)
    respond_to do |format|
      if current_user.is_admin?(@opportunity.id)
        if @opportunity.can_complete?
          if @opportunity.mark_complete
            completion_post.save
            format.html { redirect_to edit_post_path(completion_post) }
            format.json { render :new, status: :ok, location: completion_post }
          else
            format.html { redirect_to @opportunity, alert: "An unexpected error occurred." }
            format.json { render :show, status: :unprocessable_entity, location: @opportunity }
          end
        else
          format.html { redirect_to @opportunity, alert: "This opportunity cannot be completed yet. Make sure all Requirements are complete!" }
          format.json { render :show, status: :bad_request, location: @opportunity }
        end
      else
        format.html { redirect_to @opportunity, alert: "You do not have permission to do this." }
        format.json { render :show, status: :forbidden, location: @opportunity }
      end
    end
  end

  def uncomplete
    respond_to do |format|
      if current_user.is_admin?(@opportunity.id)
        if !@opportunity.completed
          if @opportunity.mark_uncompleted
            format.html { redirect_to @opportunity, notice: "This opportunity is open again." }
            format.json { render :new, status: :ok, location: @opportunity }
          else
            format.html { redirect_to @opportunity, alert: "An unexpected error occurred." }
            format.json { render :show, status: :unprocessable_entity, location: @opportunity }
          end
        else
          format.html { redirect_to @opportunity, alert: "This opportunity cannot be completed yet. Make sure all Requirements are complete!" }
          format.json { render :show, status: :bad_request, location: @opportunity }
        end
      else
        format.html { redirect_to @opportunity, alert: "You do not have permission to do this." }
        format.json { render :show, status: :forbidden, location: @opportunity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_opportunity
    @opportunity = Opportunity.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def opportunity_params
    params.require(:opportunity).permit(:title, :description, :category, :defined, :address, :target_completion_date, :postal_code, :country, :volunteers_required, :estimated_work, :status, :planned_by_date)
  end

  def promotion_params
    params.permit(:opportunity_id, :target_user_id)
  end

  def set_time_options
    @time_options = ["Weekly", "Bi-weekly", "Monthly", "Annually"]
  end
  # def add_follower_role
  #   role = Role.new
  #   return role
  # end
end
