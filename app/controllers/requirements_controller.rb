class RequirementsController < ApplicationController
  respond_to :html, :xml, :json


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





  # before_action :set_requirement, only: [:show, :edit, :update, :destroy, :participate, :cancel_participation, :promote_leader, :remove_leader, :mark_complete, :mark_incomplete, :mark_defined]
  # before_action :authenticate_user!

  # # GET /requirements/new
  # def new
  #   @requirement = Requirement.new
  #   if params[:requirement]
  #     @requirement.opportunity_id = params[:requirement][:opportunity_id]
  #     @date = params[:requirement][:target_date].to_date
  #     @planned = params[:requirement][:defined] == "true"
  #   end
  # end

  # # # GET /requirements/1
  # # def show
  # #   @volunteers = @requirement.requirement_roles.map {|r| r.user }
  # #   @opportunity = Opportunity.includes(:opportunity_roles).find(@requirement.opportunity_id)
  # #   @is_mod = current_user.is_mod?(@opportunity.id)
  # #   @is_admin = current_user.is_admin?(@requirement.opportunity.id)
  # #   @is_volunteer = current_user.is_req_volunteer?(@requirement.id)
  # #   @is_follower = current_user.is_follower?(@requirement.opportunity_id)
  # #   @leader = @requirement.requirement_roles.find_by(level: 1)
  # # end

  # # GET /requirements/1/edit
  # def edit
  #   @opportunity = Opportunity.find(@requirement.opportunity_id)
  # end

  # # POST /requirements
  # # POST /requirements.json
  # def create

  #   @requirement = Requirement.new(requirement_params)
  #   opportunity = Opportunity.find(@requirement.opportunity_id)
  #   respond_to do |format|
  #     # @tab = 'opportunity-requirements-tab'
  #     if current_user.is_mod?(opportunity.id)
  #       if @requirement.save
  #         format.html { redirect_to opportunity, notice: 'Requirement was successfully created.' }
  #         format.json { render :show, status: :created, location: @requirement }
  #       else
  #         format.html { redirect_to opportunity, alert: "An unexpected error occurred." }
  #         format.json { render :show, status: :unprocessable_entity, location: opportunity}
  #       end
  #     else
  #       format.html { rerdirect_to opportunity, alert: "You do not have permission to create a requirement for this opportunity." }
  #       format.json { render :show, status: :forbidden, location: opportunity }
  #     end
  #   end
  # end

  # # PATCH/PUT /requirements/1
  # # PATCH/PUT /requirements/1.json
  # def update
  #   @opportunity = Opportunity.find(@requirement.opportunity_id)
  #   @categories = Category.req_titles
  #   @sub_categories = Category.req_subcats
  #   respond_to do |format|
  #     if current_user == @requirement.leader || current_user == @requirement.creator || current_user.is_mod?(@opportunity.id)
  #       if @requirement.update(update_params)
  #         format.html { redirect_to @opportunity, notice: "The requirement '#{@requirement.title}' was updated successfully" }
  #         format.json { render :show, status: :ok, location: @opportunity }
  #       else
  #         format.html { render :edit }
  #         format.json { render json: @requirement.errors, status: :unprocessable_entity }
  #       end
  #     else
  #       format.html { redirect_to opportunity, alert: "You do not have permission to edit a requirement for this opportunity." }
  #       format.json { render :show, status: :forbidden, location: opportunity }
  #     end
  #   end
  # end

  # # DELETE /requirements/1
  # # DELETE /requirements/1.json
  # def destroy
  #   @opportunity = Opportunity.find(@requirement.opportunity_id)

  #   respond_to do |format|
  #     if current_user.is_admin?(@opportunity.id)
  #       @requirement.destroy
  #       format.html { redirect_to @opportunity, notice: 'Requirement.was successfully destroyed.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { redirect_to @opportunity, notice: 'You do not have permission to delete this requirement' }
  #       format.json { render :show, status: :forbidden}
  #     end
  #   end
  # end

  # def participate
  #   respond_to do |format|
  #     if current_user.is_follower?(@requirement.opportunity.id)
  #       @requirement.leader = current_user
  #       if @requirement.save
  #         format.html { redirect_to @requirement.opportunity, notice: "You are now a volunteer in #{@requirement.title}" }
  #         format.json { render :show, status: :created, location: @requirement.opportunity }
  #       else
  #         format.html { redirect_to @requirement.opportunity, notice: 'There was an unexpected issue when volunteering to participate in this requirement.' }
  #         format.json { render :show, status: :unprocessable_entity, location: @requirement.opportunity }
  #       end
  #     else
  #       format.html { redirect_to @requirement.opportunity, notice: 'You must follow this problem to volunteer for a requirement.' }
  #       format.json { render :show, status: :forbidden, location: @requirement.opportunity }
  #     end
  #   end
  # end

  # def cancel_participation
  #   respond_to do |format|
  #     if current_user == @requirement.leader
  #       @requirement.leader = nil
  #       @requirement.save
  #       format.html { redirect_to @requirement.opportunity, notice: "You have cancelled your participation." }
  #       format.json { render :show, status: :ok, location: @requirement.opportunity}
  #     else
  #       format.html { redirect_to @requirement.opportunity, alert: "You were not a volunteer."}
  #       format.json { render :show, status: :unprocessable_entity, location: @requirement.opportunity}
  #     end
  #   end
  # end

  # def promote_leader
  #   opp = @requirement.opportunity
  #   respond_to do |format|
  #     if current_user.is_mod?(opp.id)
  #       if Role.make_req_leader(promote_params, @requirement.id)
  #         format.html { redirect_to opp, notice: "#{@requirement.title} has a new leader!" }
  #         format.json { render :show, status: :ok, location: opp }
  #       else
  #         format.html { redirect_to opp, alert: "Could not complete request." }
  #         format.json { render :show, status: :unprocessable_entity, location: opp }
  #       end
  #     else
  #       format.html { redirect_to opp, notice: "You do not have permission to do this." }
  #       format.json { render :show, status: :forbidden, location: opp }
  #     end
  #   end
  # end

  # def remove_leader
  #   opp = @requirement.opportunity
  #   respond_to do |format|
  #     if current_user.is_mod?(opp.id)
  #       if Role.remove_req_leader(@requirement.id)
  #         format.html { redirect_to opp, notice: "Leader has been removed." }
  #         format.json { render :show, status: :ok, location: opp }
  #       else
  #         format.html { redirect_to opp, alert: "Could not complete request." }
  #         format.json { render :show, status: :unprocessable_entity, location: opp }
  #       end
  #     else
  #       format.html { redirect_to opp, notice: "You do not have permission to do this." }
  #       format.json { render :show, status: :forbidden, location: opp }
  #     end
  #   end
  # end

  # def mark_complete
  #   @opportunity = @requirement.opportunity
  #   respond_to do |format|
  #     if current_user.is_mod?(@opportunity.id) && @requirement.can_complete?
  #       @requirement.complete = true
  #       @requirement.status = "Complete"
  #       if @requirement.save
  #         format.html { redirect_to @opportunity, success: "#{@requirement.title} is complete!" }
  #         format.json { render :show, status: ok, location: @opportunity }
  #       else
  #         format.html { redirect_to @opportunity, alert: "Something went wrong. An error has been logged, please try again later." }
  #         format.json { render :show, status: :unprocessable_entity, location: @opportunity }
  #       end
  #     else
  #       format.html { redirect_to @opportunity, alert: "You do not have permission to mark this requirement complete." }
  #       format.json { render :show, status: :forbidden, location: @opportunity }
  #     end
  #   end
  # end

  # def mark_incomplete
  #   @opportunity = @requirement.opportunity
  #   respond_to do |format|
  #     if current_user.is_mod?(@opportunity.id) && @requirement.complete?
  #       @requirement.complete = false
  #       @requirement.status = "In Progress"
  #       if @requirement.save
  #         format.html { redirect_to @opportunity, success: "This requirement is now marked incomplete!" }
  #         format.json { render :show, status: ok, location: @opportunity }
  #       else
  #         format.html { redirect_to @opportunity, alert: "Something went wrong. An error has been logged, please try again later." }
  #         format.json { render :show, status: :unprocessable_entity, location: @opportunity }
  #       end
  #     else
  #       format.html { redirect_to @opportunity, alert: "You do not have permission to mark this requirement as incomplete." }
  #       format.json { render :show, status: :forbidden, location: @opportunity }
  #     end
  #   end
  # end

  # def mark_defined
  #   @opportunity = @requirement.opportunity
  #   respond_to do |format|
  #     if current_user.is_mod?(@opportunity.id)
  #       @requirement.defined = true
  #       @requirement.status = "Defined"
  #       if @requirement.save
  #         format.html { redirect_to @opportunity, success: "This requirement is now defined!" }
  #         format.json { render :show, status: ok, location: @opportunity }
  #       else
  #         format.html { redirect_to @opportunity, alert: "Something went wrong. An error has been logged, please try again later." }
  #         format.json { render :show, status: :unprocessable_entity, location: @opportunity }
  #       end
  #     else
  #       format.html { redirect_to @opportunity, alert: "You do not have permission to mark this requirement as defined." }
  #       format.json { render :show, status: :forbidden, location: @opportunity }
  #     end
  #   end
  # end

  # private
  # # Use callbacks to share common setup or constraints between actions.
  # def set_requirement
  #   @requirement = Requirement.find(params[:id])
  # end

  # # Never trust parameters from the scary internet, only allow the white list through.
  # def requirement_params
  #   params.require(:requirement).permit(:title, :description, :status, :complete, :opportunity_id, :address, :volunteers_required, :cleanup_date, :category, :subcategory, :defined, :creator_id, :priority, :pct_done, :estimated_work)
  # end

  # def update_params
  #   params.require(:requirement).permit(:title, :description, :status, :complete, :address, :volunteers_required, :cleanup_date, :category, :subcategory, :defined, :user_id, :priority, :pct_done, :estimated_work)
  # end

  # def promote_params
  #   params.require(:user_id)
  # end

  # def participate_params
  #   params.require(:requirement_id)
  # end

  # def cancel_params
  #   params.require(:requirement_id)
  # end
end
