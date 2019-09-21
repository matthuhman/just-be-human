class RequirementsController < ApplicationController
  respond_to :html, :xml, :json


  before_action :set_requirement, only: [:show, :edit, :update, :destroy, :participate, :cancel_participation, :promote_leader, :remove_leader, :mark_complete, :mark_incomplete]
  before_action :authenticate_user!

  # GET /requirements/new
  def new
    @categories = Category.req_titles
    @sub_categories = Category.req_subcats
    @requirement = Requirement.new
    if params[:requirement]
      @date = params[:requirement][:target_date].to_date
      @planned = params[:requirement][:defined]
    end
  end

  # GET /requirements/1
  def show
    @volunteers = @requirement.requirement_roles.map {|r| r.user }
    @opportunity = Opportunity.includes(:opportunity_roles).find(@requirement.opportunity_id)
    @is_mod = current_user.is_mod?("requirement", @requirement.id)
    @is_admin = current_user.is_admin?(@requirement.opportunity.id)
    @is_volunteer = current_user.is_volunteer?(@requirement.id)
    @is_follower = current_user.is_follower?(@requirement.opportunity_id)
    @leader = @requirement.requirement_roles.find_by(level: 1)
  end

  # GET /requirements/1/edit
  def edit
    @opportunity = Opportunity.find(@requirement.opportunity_id)
    @categories = Category.req_titles
    @sub_categories = Category.req_subcats
    @planned = @opportunity.defined
  end

  # POST /requirements
  # POST /requirements.json
  def create

    @requirement = Requirement.new(requirement_params)
    opportunity = Opportunity.find(@requirement.opportunity_id)
    @categories = Category.req_titles
    respond_to do |format|
      # @tab = 'opportunity-requirements-tab'
      if current_user.is_mod?(opportunity.id)
        if @requirement.save
          format.html { redirect_to @requirement, notice: 'Requirement was successfully created.' }
          format.json { render :show, status: :created, location: @requirement }
        else
          format.html { redirect_to opportunity, alert: "An unexpected error occurred." }
          format.json { render :show, status: :unprocessable_entity, location: opportunity}
        end
      else
        format.html { rerdirect_to opportunity, alert: "You do not have permission to create a requirement for this opportunity." }
        format.json { render :show, status: :forbidden, location: opportunity }
      end
    end
  end

  # PATCH/PUT /requirements/1
  # PATCH/PUT /requirements/1.json
  def update
    @opportunity = Opportunity.find(@requirement.opportunity_id)
    @categories = Category.req_titles
    @sub_categories = Category.req_subcats
    respond_to do |format|
      if current_user.id == @requirement.user_id || current_user.is_mod?(@opportunity.id)
        if @requirement.update(update_params)
          format.html { redirect_to @opportunity, notice: "The requirement '#{@requirement.title}' was updated successfully" }
          format.json { render :show, status: :ok, location: @opportunity }
        else
          format.html { render :edit }
          format.json { render json: @requirement.errors, status: :unprocessable_entity }
        end
      else
        format.html { rerdirect_to opportunity, alert: "You do not have permission to edit a requirement for this opportunity." }
        format.json { render :show, status: :forbidden, location: opportunity }
      end
    end
  end

  # DELETE /requirements/1
  # DELETE /requirements/1.json
  def destroy
    @opportunity = Opportunity.find(@requirement.opportunity_id)

    respond_to do |format|
      if current_user.is_admin?(@opportunity.id)
        @requirement.destroy
        format.html { redirect_to @opportunity, notice: 'Requirement.was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @opportunity, notice: 'You do not have permission to delete this requirement' }
        format.json { render :show, status: :forbidden}
      end
    end
  end

  def participate
    respond_to do |format|
      if Role.volunteer(current_user.id, @requirement.id, @requirement.opportunity_id)
        format.html { redirect_to @requirement, notice: "You are now a volunteer in #{@requirement.title}" }
        format.json { render :show, status: :created, location: @requirement }
      else
        format.html { redirect_to @requirement, notice: 'There was an unexpected issue when volunteering to participate in this requirement.' }
        format.json { render :show, status: :unprocessable_entity, location: @requirement }
      end
    end
  end

  def cancel_participation
    respond_to do |format|
      if Role.cancel(current_user.id, @requirement.id, @requirement.opportunity_id)
        format.html { redirect_to @requirement, notice: "You have cancelled your participation." }
        format.json { render :show, status: :ok, location: @requirement}
      else
        format.html { redirect_to @requirement, alert: "You were not a volunteer."}
        format.json { render :show, status: :unprocessable_entity, location: @requirement}
      end
    end
  end

  def promote_leader
    opp = @requirement.opportunity
    respond_to do |format|
      if current_user.is_mod?(opp.id)
        if Role.make_req_leader(promote_params, @requirement.id)
          format.html { redirect_to @requirement, notice: "#{@requirement.title} has a new leader!" }
          format.json { render :show, status: :ok, location: @requirement }
        else
          format.html { redirect_to @requirement, alert: "Could not complete request." }
          format.json { render :show, status: :unprocessable_entity, location: @requirement }
        end
      else
        format.html { redirect_to @requirement, notice: "You do not have permission to do this." }
        format.json { render :show, status: :forbidden, location: @requirement }
      end
    end
  end

  def remove_leader
    opp = @requirement.opportunity
    respond_to do |format|
      if current_user.is_mod?(opp.id)
        if Role.remove_req_leader(@requirement.id)
          format.html { redirect_to @requirement, notice: "Leader has been removed." }
          format.json { render :show, status: :ok, location: @requirement }
        else
          format.html { redirect_to @requirement, alert: "Could not complete request." }
          format.json { render :show, status: :unprocessable_entity, location: @requirement }
        end
      else
        format.html { redirect_to @requirement, notice: "You do not have permission to do this." }
        format.json { render :show, status: :forbidden, location: @requirement }
      end
    end
  end

  def mark_complete
    @opportunity = @requirement.opportunity
    respond_to do |format|
      if current_user.is_mod?(@opportunity.id) && @requirement.can_complete?
        @requirement.complete = true
        @requirement.status = "Complete"
        if @requirement.save
          format.html { redirect_to @requirement, success: "This requirement is complete!" }
          format.json { render :show, status: ok, location: @requirement }
        else
          format.html { redirect_to @requirement, alert: "Something went wrong. An error has been logged, please try again later." }
          format.json { render :show, status: :unprocessable_entity, location: @requirement }
        end
      else
        format.html { redirect_to @requirement, alert: "You do not have permission to mark this requirement complete." }
        format.json { render :show, status: :forbidden, location: @requirement }
      end
    end
  end

  def mark_incomplete
    @opportunity = @requirement.opportunity
    respond_to do |format|
      if current_user.is_mod?(@opportunity.id) && @requirement.complete?
        @requirement.complete = false
        @requirement.status = "In Progress"
        if @requirement.save
          format.html { redirect_to @requirement, success: "This requirement is now marked incomplete!" }
          format.json { render :show, status: ok, location: @requirement }
        else
          format.html { redirect_to @requirement, alert: "Something went wrong. An error has been logged, please try again later." }
          format.json { render :show, status: :unprocessable_entity, location: @requirement }
        end
      else
        format.html { redirect_to @requirement, alert: "You do not have permission to mark this requirement as incomplete." }
        format.json { render :show, status: :forbidden, location: @requirement }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_requirement
    @requirement = Requirement.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def requirement_params
    params.require(:requirement).permit(:title, :description, :status, :complete, :opportunity_id, :address, :volunteers_required, :target_completion_date, :category, :subcategory, :defined, :user_id, :priority, :pct_done, :estimated_work)
  end

  def update_params
    params.require(:requirement).permit(:title, :description, :status, :complete, :address, :volunteers_required, :target_completion_date, :category, :subcategory, :defined, :user_id, :priority, :pct_done, :estimated_work)
  end

  def promote_params
    params.require(:user_id)
  end

  def participate_params
    params.require(:requirement_id)
  end

  def cancel_params
    params.require(:requirement_id)
  end
end
