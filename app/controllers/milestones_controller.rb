class MilestonesController < ApplicationController
  before_action :set_milestone, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /milestones/new
  def new
    @milestone = Milestone.new
  end

  # GET /milestones/1
  def show
    @problem = Problem.find(@milestone.problem_id)
    @role = Role.find_by(user_id: current_user.id, problem_id: @problem.id)
    @ms_role = MilestoneRole.find_by(user_id: current_user.id, milestone_id: @milestone.id)
  end

  # GET /milestones/1/edit
  def edit
  end

  # POST /milestones
  # POST /milestones.json
  def create
    @milestone = Milestone.new(milestone_params)
    problem = Problem.find(@milestone.problem_id)

    if @milestone.participants_required > problem.participants_required
      problem.participants_required = @milestone.participants_required
      problem.save
    end

    respond_to do |format|
      if problem.user_has_mod_permissions(current_user.id)
        if @milestone.save
          format.html { redirect_to problem, notice: 'Milestone was successfully created.' }
          format.json { render :show, status: :created, location: problem }
        else
          format.html { render :new }
          format.json { render json: @milestone.errors, status: :unprocessable_entity }
        end
      else
        format.html { rerdirect_to problem, alert: "You do not have permission to create a milestone for this problem." }
        format.json { render :show, status: :forbidden, location: problem }
      end
    end
  end

  def participate
    @milestone = Milestone.find(params[:milestone_id])
    @role = MilestoneRole.create(participate_params)
    @role.title = "Participant"
    @role.level = 3
    @role.user_id = current_user.id
    respond_to do |format|
      if @role.save
        Milestone.increment_counter(:participant_count, @milestone.id)
        format.html { redirect_to @milestone, notice: 'You are now a participant in #{@milestone.title}' }
        format.json { render :show, status: :created, location: @milestone }
      else
        format.html { redirect_to @milestone, notice: 'There was a problem when volunteering to participate in this milestone.' }
        format.json { render :show, status: :unprocessable_entity, location: @milestone }
      end
    end
  end

  def cancel_participation
    @milestone = Milestone.find(cancel_params[:milestone_id])
    @problem = 
    @role = MilestoneRole.find_by(user_id: current_user.id, milestone_id: params[:milestone_id])
    respond_to do |format|
      if (@role)
        @role.destroy
        Milestone.decrement_counter(:participant_count, @milestone.id)
        format.html { redirect_to @milestone, notice: "You have cancelled your participation." }
        format.json { render :show, status: :ok, location: @milestone}
      else
        format.html { redirect_to @milestone, alert: "You were not a participant."}
        format.json { render :show, status: :unprocessable_entity, location: @milestone}
      end
    end
  end

  # PATCH/PUT /milestones/1
  # PATCH/PUT /milestones/1.json
  def update
    @problem = Problem.find(@milestone.problem_id)

    respond_to do |format|
      if current_user.id == @milestone.user_id || @problem.user_has_mod_permissions(current_user.id) || @milestone.user_has_mod_permissions(current_user.id)
        if @milestone.update(milestone_params)
          format.html { redirect_to @problem, notice: 'Milestone was successfully updated.' }
          format.json { render :show, status: :ok, location: @problem }
        else
          format.html { render :edit }
          format.json { render json: @milestone.errors, status: :unprocessable_entity }
        end
      else
        format.html { rerdirect_to problem, alert: "You do not have permission to edit a milestone for this problem." }
        format.json { render :show, status: :forbidden, location: problem }
      end
    end
  end

  # DELETE /milestones/1
  # DELETE /milestones/1.json
  def destroy
    @problem = Problem.find(@milestone.problem_id)
    
    respond_to do |format|
      if current_user.id == @milestone.user_id || @problem.user_has_mod_permissions(current_user.id) || @milestone.user_has_mod_permissions(current_user.id)
        @milestone.destroy
        format.html { redirect_to @problem, notice: 'Milestone was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @problem, notice: 'You do not have permission to delete this milestone' }
        format.json { render :show, status: :forbidden}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_milestone
      @milestone = Milestone.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def milestone_params
      params.require(:milestone).permit(:title, :description, :current_status, :complete, :problem_id, :address, :participants_required)
    end

    def participate_params
      params.permit(:milestone_id)
    end

    def cancel_params
      params.permit(:milestone_id)
    end
end
