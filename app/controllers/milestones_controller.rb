class MilestonesController < ApplicationController
  before_action :set_milestone, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /milestones/new
  def new
    @milestone = Milestone.new
  end

  # GET /milestones/1/edit
  def edit
  end

  # POST /milestones
  # POST /milestones.json
  def create
    @milestone = Milestone.new(milestone_params)
    problem = Problem.find(@milestone.problem_id)
    problem_role = Role.find_by(user_id: current_user.id, problem_id: problem.id)


    respond_to do |format|
      if problem_role && problem_role.level <= 2
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

  # PATCH/PUT /milestones/1
  # PATCH/PUT /milestones/1.json
  def update
    @problem = Problem.find(@milestone.problem_id)
    problem_role = Role.find_by(user_id: current_user.id, problem_id: problem.id)
    milestone_role = MilestoneRole.find_by(user_id: current_user.id, milestone_id: @milestone.id)

    respond_to do |format|
      if (problem_role && problem_role.level <= 2) || (milestone_role && milestone_role.level <= 2)
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
    problem_role = Role.find_by(user_id: current_user.id, problem_id: problem.id)
    
    respond_to do |format|
      if problem_role && problem_role.level <= 2
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
      params.require(:milestone).permit(:title, :description, :current_status, :complete, :problem_id, :address)
    end
end
