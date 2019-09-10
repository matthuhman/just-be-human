class RequirementsController < ApplicationController
  respond_to :html, :xml, :json


  before_action :set_requirement, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /requirements/new
  def new
    @categories = Category.req_titles
    @sub_categories = Category.req_subcats
    @requirement = Requirement.new
    if params[:requirement]
      @date = params[:requirement][:target_date].to_date
      @planned = params[:requirement][:defined]
      # 
    end
    respond_modal_with @requirement
  end

  # GET /requirements/1
  def show
    @problem = Problem.find(@requirement.problem_id)
    @prob_level = Role.problem_role_level(current_user.id, @problem.id)
    @req_level = Role.requirement_role_level(current_user.id, @requirement.id)
    @overdue = Date.today > @requirement.target_completion_date
    respond_modal_with @requirement
  end

  # GET /requirements/1/edit
  def edit
    @problem = Problem.find(@requirement.problem_id)
    @categories = Category.req_titles
    @sub_categories = Category.req_subcats
    respond_modal_with @requirement, title: "Editing requirement"
  end

  # POST /requirements
  # POST /requirements.json
  def create
    
    @requirement = Requirement.new(requirement_params)
    problem = Problem.find(@requirement.problem_id)
    @categories = Category.req_titles
    @sub_categories = Category.req_subcats
    #respond_modal_with @requirement, location: @problem
    respond_to do |format|
      @tab = 'problem-requirements-tab'
      if problem.user_has_mod_permissions(current_user.id)
        if @requirement.save
          format.html { redirect_to problem, notice: 'Requirement was successfully created.' }
          format.json { render :show, status: :created, location: problem }
        else
          respond_modal_with @requirement
          # format.html { render :new }
          # format.json { render json: @requirement.errors, status: :unprocessable_entity }
        end
      else
        format.html { rerdirect_to problem, alert: "You do not have permission to create a requirement for this problem." }
        format.json { render :show, status: :forbidden, location: problem }
      end
    end
  end

  # PATCH/PUT /requirements/1
  # PATCH/PUT /requirements/1.json
  def update
    @problem = Problem.find(@requirement.problem_id)
    @categories = Category.req_titles
    @sub_categories = Category.req_subcats
    respond_to do |format|
      if current_user.id == @requirement.user_id || @problem.user_has_mod_permissions(current_user.id) || @requirement.user_has_mod_permissions(current_user.id)
        if @requirement.update(update_params)
          format.html { redirect_to @problem, notice: "The requirement '#{@requirement.title}' was updated successfully" }
          format.json { render :show, status: :ok, location: @problem }
        else
          format.html { render :edit }
          format.json { render json: @requirement.errors, status: :unprocessable_entity }
        end
      else
        format.html { rerdirect_to problem, alert: "You do not have permission to edit a requirement for this problem." }
        format.json { render :show, status: :forbidden, location: problem }
      end
    end
  end

  # DELETE /requirements/1
  # DELETE /requirements/1.json
  def destroy
    @problem = Problem.find(@requirement.problem_id)

    respond_to do |format|
      if current_user.id == @requirement.user_id || @problem.user_has_mod_permissions(current_user.id) || @requirement.user_has_mod_permissions(current_user.id)
        @requirement.destroy
        format.html { redirect_to @problem, notice: 'Requirement.was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @problem, notice: 'You do not have permission to delete this requirement' }
        format.json { render :show, status: :forbidden}
      end
    end
  end

  def participate
    @requirement = Requirement.find(params[:requirement_id])
    respond_to do |format|
      if Role.volunteer(current_user.id, @requirement.id, @requirement.problem_id)
        format.html { redirect_to @requirement, notice: "You are now a volunteer in #{@requirement.title}" }
        format.json { render :show, status: :created, location: @requirement }
      else
        format.html { redirect_to @requirement, notice: 'There was a problem when volunteering to participate in this requirement.' }
        format.json { render :show, status: :unprocessable_entity, location: @requirement }
      end
    end
  end

  def cancel_participation
    @requirement = Requirement.find(cancel_params[:requirement_id])
    respond_to do |format|
      if Role.cancel(current_user.id, @requirement.id, @requirement.problem_id)
        format.html { redirect_to @requirement, notice: "You have cancelled your participation." }
        format.json { render :show, status: :ok, location: @requirement}
      else
        format.html { redirect_to @requirement, alert: "You were not a volunteer."}
        format.json { render :show, status: :unprocessable_entity, location: @requirement}
      end
    end
  end

  def change_completion_status
    @requirement = Requirement.find(:requirement_id)
    current_status = @requirement.complete
    @problem = @requirement.problem
    respond_to do |format|
      if @requirement.user_has_mod_permissions(current_user.id) || @problem.user_has_mod_permissions
        requirement.complete = !current_status;
        if requirement.save
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


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_requirement
      @requirement = Requirement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def requirement_params
      params.require(:requirement).permit(:title, :description, :current_status, :complete, :problem_id, :address, :volunteers_required, :target_completion_date, :category, :subcategory, :defined, :user_id, :priority, :pct_work_remaining, :estimated_work)
    end

    def update_params
      params.require(:requirement).permit(:title, :description, :current_status, :complete, :address, :volunteers_required, :target_completion_date, :category, :subcategory, :defined, :user_id, :priority, :pct_work_remaining, :estimated_work)
    end

    def participate_params
      params.permit(:requirement_id)
    end

    def cancel_params
      params.permit(:requirement_id)
    end
end
